//
//  File.swift
//  
//
//  Created by Apple on 23/08/2023.
//

import Foundation
import core_architecture
import Dependencies
import Debugger

public class Network: Networking {
    enum NetworkLogAction {
    case url, createRequest, sendRequest, receiveData(Data), throwsError
    }
    struct NetworkDebugDataModel: DataModel {
        var debugData: Data
        init(debugData: Data) {
            self.debugData = debugData
        }
    }
    private let logger: Logs<NetworkLogAction> = .init(id: "com.core_architecture.network.logs")
    @Dependency(\.networkDebugger) var debugger
    public var session: SessionManager
    private var tasks: [String: SessionTask] = [:]
    public required init(session: SessionManager) {
        self.session = session
    }
    public func send(with data: DataModel?, config: NetworkConfig) async throws -> DataModel {
        try await _send(with: data, config: config)
    }
    private func _send(with data: DataModel?, config: NetworkConfig) async throws -> DataModel {
        guard var url = URL(string: "\(config.host.hostScheme)/\(config.to.pointing)") else {
            throw NetworkErrorCode.invalidURL
        }
        logger.log(url, action: .url)
        var request = URLRequest(url: url)
        request.httpMethod = config.method.rawValue
        request.allHTTPHeaderFields = config.headers
        switch config.contentType {
        case .queryParam:
            if let params = try await config.contentType.encoder.encode(data: data),
                params.isNotEmpty {
                url.insert(params: params)
                request.url = url
            }
            
        case .postFormData:
            request.httpBody = try await config.contentType.encoder.encode(data: data)?.data(using: .utf8)
            request.setValue(config.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        case .applicationJSON:
            request.httpBody = try await config.contentType.encoder.encode(data: data)?.data(using: .utf8)
            request.setValue(config.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        logger.log(request, action: .createRequest)
        return try await sendRequest(request: request, config: config)
    }
    private func sendRequest(request: URLRequest, config: NetworkConfig) async throws -> DataModel {
        try await withCheckedThrowingContinuation({
            [weak self]
            continuation in
            guard let welf = self else {
                continuation.resume(throwing: SystemError.network(.methodNotAllowed))
                return
            }
            do {
                let requestDebuggingResult = try welf.debugger.debug(debug: config.to, feature: NetworkRequestDebug.self)
                switch requestDebuggingResult {
                case .console:
                    if let action = welf.debugger.action(actionType: NetworkDebuggerActions.self) {
                        action.action(.init(configID: config.to.configID, debugID: config.to.debugID, debugData: .request(request))) {
                            [weak self]
                            returnedAction in
                            guard let welf = self else {
                                continuation.resume(throwing: SystemError.network(.methodNotAllowed))
                                return
                            }
                            switch returnedAction.debugData {
                            case .request(let newRequest):
                                welf.sendRequest(request: newRequest, config: config, completion: {
                                    [weak self ]
                                    error, returnedData in
                                    guard let welf = self else {
                                        continuation.resume(throwing: SystemError.network(.methodNotAllowed))
                                        return
                                    }
                                    welf.processResponse(config: config, data: returnedData, error: error, continuation: continuation)
                                })
                                break
                            default:
                                break

                            }
                        }
                    }
                case .ignore:
                    welf.sendRequest(request: request, config: config, completion: {
                        [weak self ]
                        error, returnedData in
                        guard let welf = self else {
                            continuation.resume(throwing: SystemError.network(.methodNotAllowed))
                            return
                        }
                        welf.processResponse(config: config, data: returnedData, error: error, continuation: continuation)
                    })
                }
            } catch let err { continuation.resume(throwing: err) }
        })
//        try await withUnsafeThrowingContinuation({
//            [weak self]
//            (continuation: CheckedContinuation<DataModel, Error>) in
            
//        })
    }
    private func sendRequest(request: URLRequest, config: NetworkConfig, completion: @escaping (SystemError?, DataModel?) -> ()) {
        let requestID = UUID().uuidString
        let sessionTask = session.task(with: request) {
            [weak self, requestID]
            data, response, error in
            if let data {
                do {
                    self?.logger.log(data, action: .receiveData(data))
                    let dataModel = try JSONDecoder().decode(config.responseType, from: data)
                    completion(nil, dataModel)
                }
                catch let err {
                    self?.logger.log(err, action: .throwsError)
                    completion(.custom(err), nil)
                }
            }
            else {
                self?.logger.log(error, action: .throwsError)
                completion(error == nil ? nil : .custom(error!), nil)
            }
            self?.tasks.removeValue(forKey: requestID)
        }
        if let sessionTask {
            tasks[requestID] = sessionTask
            sessionTask.resume()
            logger.log(request, action: .sendRequest)
        }
    }
    private func processResponse(config: NetworkConfig, data: DataModel?, error: SystemError?, continuation: CheckedContinuation<DataModel, Error>) {
        if let data {
            debugData(config: config, data: data, continuation: continuation)
        }
        else if let error {
            debugError(config: config, error: error, continuation: continuation)
        }else {
            continuation.resume(throwing: SystemError.network(.notFound))
        }
    }
    private func debugData(config: NetworkConfig, data: DataModel, continuation: CheckedContinuation<DataModel, Error>) {
        do {
            let debugResult = try self.debugger.debug(debug: config.to, feature: NetworkDataDebug.self)
            switch debugResult {
            case .console:
                if let action = self.debugger.action(actionType: NetworkDebuggerActions.self)?.action {
                    action(.init(configID: config.to.configID, debugID: config.to.debugID, debugData: .data(data, config.responseType))) { actionback in
                        if case .data(let dataModel, _) = actionback.debugData {
                            continuation.resume(returning: dataModel)
                        }else {
                            continuation.resume(returning: data)
                        }
                    }
                }else {
                    continuation.resume(returning: data)
                    break
                }
            case .ignore:
                continuation.resume(returning: data)
                break
            }
        }
        catch let error {
            continuation.resume(throwing: error)
        }
    }
    private func debugError(config: NetworkConfig, error: Error, continuation: CheckedContinuation<DataModel, Error>) {
        do {
            let debugResult = try self.debugger.debug(debug: config.to, feature: NetworkErrorDebug.self)
            switch debugResult {
            case .console:
                if let action = self.debugger.action(actionType: NetworkDebuggerActions.self)?.action {
                    action(.init(configID: config.to.configID, debugID: config.to.debugID,debugData: .error(error))) { actionBack in
                        if case .error(let freshError) = actionBack.debugData {
                            continuation.resume(throwing: SystemError.custom(freshError))
                        }
                    }
                }else {
                    continuation.resume(throwing: SystemError.custom(error))
                    break
                }
            case .ignore:
                continuation.resume(throwing: SystemError.custom(error))
                break
            }
        }
        catch let error {
            continuation.resume(throwing: error)
        }
    }
}


extension Network.NetworkLogAction: LogAction {
    var rawValue: String {
        switch self {
        case .url:
            return "Generated URL"
        case .createRequest:
            return "Created Request"
        case .sendRequest:
            return "Sent Request"
        case .receiveData(let data):
            do {
                return try data.prettyJSONString()
            }
            catch let err {
                return err.localizedDescription
            }
        case .throwsError:
            return "Received Error"
        }
    }
}
