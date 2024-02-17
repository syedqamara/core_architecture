//
//  File.swift
//  
//
//  Created by Apple on 23/08/2023.
//

import Foundation
import Core
import Dependencies
import Debugger

public class Network: Networking {
    public typealias NetworkConfigType = NetworkConfig
    enum NetworkLogAction {
    case url, createRequest, sendRequest, receiveData, throwsError
    }
    struct NetworkDebugDataModel: DataModel {
        var debugData: Data
        init(debugData: Data) {
            self.debugData = debugData
        }
    }
    private let logger: Logs<NetworkLogAction> = .init(id: "com.Core.network.logs")
    @Dependency(\.networkDebugger) var debugger
    public var session: SessionManager
    private var tasks: [String: SessionTask] = [:]
    private var encoder: EncodingProtocol
    private var decoder: DecodingProtocol
    public required init(session: SessionManager, encoder: EncodingProtocol, decoder: DecodingProtocol) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        
    }
    public func send(with data: DataModel?, config: NetworkConfig) async throws -> DataModelProtocol {
        try await _send(with: data, config: config)
    }
    private func _send(with data: DataModel?, config: NetworkConfig) async throws -> DataModelProtocol {
        guard var url = config.url else {
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
        return try await setupDebuggerAndSend(requestData: data, request: request, config: config)
    }
    private func setupDebuggerAndSend(requestData: DataModel?, request: URLRequest, config: NetworkConfig) async throws -> DataModelProtocol {
        let continuation = Continuation<DataModelProtocol, Error>()
        let requestContinuation = Continuation<URLRequest, Error>()
        
        // Invoke the Action When Debugger Allows to send Request
        requestContinuation.onRecieving {
            [weak self, continuation]
            newRequest in
            guard let self else { return }
            self.setupCachePolicyAndSendRequest(requestData: requestData, request: newRequest, config: config) {
                [weak self]
                error, returnedData in
                guard let self else {
                    continuation.resume(throwing: SystemError.network(.methodNotAllowed))
                    return
                }
                self.processResponse(config: config, data: returnedData, error: error, continuation: continuation)
            }
        }
        // Throw the Error When Debugger is debugging Request
        requestContinuation.onThrowing {
            [continuation]
            newError in
            continuation.resume(throwing: newError)
        }
        
        return try await withCheckedThrowingContinuation({
            [weak self, continuation]
            cont in
            
            continuation.onRecieving {
                data in
                cont.resume(returning: data)
            }
            continuation.onThrowing {
                error in
                cont.resume(throwing: error)
            }
            guard let self else {
                continuation.resume(throwing: SystemError.network(.methodNotAllowed))
                return
            }
            self.debugger.debugRequest(config: config.to, request: request, continuation: requestContinuation)
        })
    }
    private func setupCachePolicyAndSendRequest(requestData: DataModel?, request: URLRequest, config: NetworkConfig, completion: @escaping (SystemError?, DataModelProtocol?) -> ()) {
        switch config.cachePolicy {
        case .noCache:
            performNetworkRequest(
                requestData: requestData,
                request: request,
                config: config,
                completion: completion
            )
        case .cacheWhenNoNetwork:
            if Internet.shared.isAvailable() {
                performNetworkRequest(
                    requestData: requestData,
                    request: request,
                    config: config,
                    completion: completion
                )
            } else {
                checkCacheAndSendRequest(
                    requestData: requestData,
                    request: request,
                    config: config,
                    completion: completion
                )
            }
        case .cacheEveryTime:
            checkCacheAndSendRequest(
                requestData: requestData,
                request: request,
                config: config,
                completion: completion
            )
        }
    }
    private func checkCacheAndSendRequest(requestData: DataModel?, request: URLRequest, config: NetworkConfig, completion: @escaping (SystemError?, DataModelProtocol?) -> ()) {
        @NetworkCache(url: request.url!) var dataCache
        if let dataCache {
            do {
                let dataModel = try decoder.decode(data: dataCache, type: config.responseType)
                completion(nil, dataModel)
            }
            catch let err {
                completion(.custom(err), nil)
            }
        } else {
            performNetworkRequest(
                requestData: requestData,
                request: request,
                config: config) {
                    [weak self]
                    error, dataModel in
                    guard let self else {return}
                    if let dataModel {
                        do {
                            let data = try self.encoder.encode(data: dataModel)
                            _dataCache.wrappedValue = data
                        }
                        catch let err {
                            completion(.custom(err), nil)
                            return
                        }
                    }
                    completion(error, dataModel)
                }
        }
    }
    private func performNetworkRequest(requestData: DataModel?, request: URLRequest, config: NetworkConfig, completion: @escaping (SystemError?, DataModelProtocol?) -> ()) {
        let requestID = UUID().uuidString
        let sessionTask = session.task(with: request) {
            [weak self, requestID]
            data, response, error in
            @Configuration<NetworkPacket>("\(config.id)") var packet: NetworkPacket?
            _packet.wrappedValue = .init(
                config: config,
                request: NetworkPacket.NetworkRequest(
                    requestSent: request,
                    requestData: requestData
                ),
                response: NetworkPacket.NetworkResponse(
                    response: response,
                    data: data,
                    error: error
                )
            )
            
            if let data {
                do {
                    self?.logger.log(data, action: .receiveData)
                    let dataModel = try self?.decoder.decode(data: data, type: config.responseType)
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
    private func processResponse(config: NetworkConfig, data: DataModelProtocol?, error: SystemError?, continuation: Continuation<DataModelProtocol, Error>) {
        if let data {
            self.debugger.debugData(config: config.to, type: config.responseType, data: data, continuation: continuation)
        }
        else if let error {
            self.debugger.debugError(config: config.to, error: error, continuation: continuation)
        }else {
            continuation.resume(throwing: SystemError.network(.notFound))
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
        case .receiveData:
            return "Received Data"
        case .throwsError:
            return "Received Error"
        }
    }
}
