//
//  Network.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 16/05/2023.
//

import Foundation
import core_architecture
protocol DataDecoder {
    init()
    func decode<T: Decodable>(type: T.Type, data: Data) throws -> T
}

class Network<R: NetworkRequestProviderProtocol, D: DataDecoder>: Networking {
    typealias DebugConsoleAction = (DebugActions) -> ()
    enum DebugActions {
    case request(URLRequest), data(Data), error(Error), response(URLResponse)
    }
    enum NetworkLogActions: LogAction {
        case validating, requesting, parsing, responsing, throwing
        
        var rawValue: String{
            switch self {
            case .validating:
                return "Validation a network request"
            case .requesting:
                return "Sending a network request"
            case .parsing:
                return "Parsing returned response"
            case .responsing:
                return "Responding back to network caller"
            case .throwing:
                return "Throwing back to network caller"
            }
        }
    }
    typealias RequestProvider = R
    private let session = URLSession.shared
    private let dataDecoder: D = .init()
    private let debugger = NetworkDebugger()
    private let logger = Logs<NetworkLogActions>(id: "com.networking.logs")
    private let debugAction: DebugConsoleAction?
    public init(debugAction: DebugConsoleAction? = nil) {
        self.debugAction = debugAction
    }
    func run<DM>(requestProvider: R, dataType: DM.Type, completion: @escaping (Result<DM, NetworkError>) -> ()) where DM : DataModel {
        guard let urlRequest = requestProvider.request else {
            let result: Result<DM, NetworkError> = .failure(.standard(.badRequest))
            logger.log(result, action: .validating)
            completion(result)
            return
        }
        if isDebugEnabled(request: urlRequest, requestProvider: requestProvider) {
            if performDebugAction(action: .request(urlRequest)) {
                return
            }
        }
        logger.log(urlRequest, action: .requesting)
        session.dataTask(with: urlRequest) { data, resp, error in
            DispatchQueue.main.async {
                if let error {
                    self.logger.log(error, action: .throwing)
                    completion(.failure(.custom(error)))
                }
                if let data {
                    do {
                        self.logger.log(data, action: .parsing)
                        let model = try self.dataDecoder.decode(type: dataType, data: data)
                        completion(.success(model))
                    }
                    catch let err {
                        self.logger.log(error, action: .throwing)
                        completion(.failure(.custom(err)))
                    }
                }
            }
        }.resume()
    }
    private func isDebugEnabled(request: URLRequest, requestProvider: R) -> Bool {
        let result = debugger.debug(identifier: request, debug: requestProvider)
        switch result {
        case .ignore:
            return true
        default:
            return false
        }
    }
    private func performDebugAction(action: DebugActions) -> Bool {
        if let debugAction {
            debugAction(action)
            return true
        }
        return false
    }
}

extension URLRequest: DebugingID {
    public var id: String { url?.absoluteString ?? ""}
}

extension Network {
    func api<DM>(requestProvider: R, dataType: DM.Type, completion: @escaping (Result<DM, NetworkError>) -> ()) where DM : Responsable {
        run(requestProvider: requestProvider, dataType: dataType) { result in
            switch result {
            case .success(let success):
                if success.code >= 200 && success.code <= 204 {
                    completion(.success(success))
                }else {
                    completion(.failure(.standard(.unauthorized)))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
