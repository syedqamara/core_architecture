//
//  File.swift
//  
//
//  Created by Apple on 23/08/2023.
//

import Foundation
import core_architecture

protocol Pointable: Debugable {
    var pointing: String { get }
}
protocol Hosting {
    var host: String { get }
    var domain: String { get }
    var port: String { get }
}
protocol Networking {
    var host: Hosting { get }
    var debugger: Debugging { get }
    var requestEncoder: any NetworkRequestEncoding { get }
    func send(to: Pointable, method: HTTPMethod, with data: DataModel?, contentType: ContentType, headers: [String: String]) async throws -> Data
}
protocol NetworkRequestEncoding {
    func encode(data: DataModel?) async throws -> String?
}
struct GetNetworkRequestEncoder: NetworkRequestEncoding {
    func encode(data: DataModel?) async throws -> String? {
        guard let dictionary = data?.data?.dictionary()?.headersDictionary else { return nil }
        let queryParamString = dictionary.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return queryParamString
    }
}
struct PostFormNetworkRequestEncoder: NetworkRequestEncoding {
    func encode(data: DataModel?) async throws -> String? {
        guard let dictionary = data?.data?.dictionary()?.headersDictionary else { return nil }
        let queryParamString = dictionary.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return queryParamString
    }
}
struct PostJSONNetworkRequestEncoder: NetworkRequestEncoding {
    func encode(data: DataModel?) async throws -> String? {
        guard let queryParamString = try data?.data?.prettyJSONString() else { return nil }
        return queryParamString
    }
}
enum HTTPMethod: String {
case get, post, put
    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}
enum ContentType: String {
    case queryParam, postFormData, applicationJSON
    
    var rawValue: String {
        switch self {
        case .queryParam:
            return ""
        case .postFormData:
            return "url-form-encoded"
        case .applicationJSON:
            return "application/json"
        }
    }
}


class Network: Networking {
    var host: Hosting
    var debugger: Debugging
    var requestEncoder: NetworkRequestEncoding
    var session: URLSession
    init(host: Hosting, debugger: Debugging, requestEncoder: NetworkRequestEncoding, session: URLSession) {
        self.host = host
        self.debugger = debugger
        self.requestEncoder = requestEncoder
        self.session = session
    }
    func send(to: Pointable, method: HTTPMethod, with data: DataModel?, contentType: ContentType, headers: [String: String] = [:]) async throws -> Data {
        guard var url = URL(string: "\(host.host)/\(to.pointing)") else {
            throw NetworkErrorCode.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        switch contentType {
        case .queryParam:
            if let params = try await requestEncoder.encode(data: data),
                params.isNotEmpty {
                url.insert(params: params)
                request.url = url
            }
            
        case .postFormData:
            request.httpBody = try await requestEncoder.encode(data: data)?.data(using: .utf8)
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        case .applicationJSON:
            request.httpBody = try await requestEncoder.encode(data: data)?.data(using: .utf8)
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        return try await sendRequest(request: request, to: to)
    }
    private func sendRequest(request: URLRequest, to: Pointable) async throws -> Data {
        let requestDebuggingResult = debugger.debug(debug: to)
        return try await withCheckedThrowingContinuation({
            [weak self]
            (continuation: CheckedContinuation<Data, Error>) in
            switch requestDebuggingResult {
            case .console:
                if let action = self?.debugger.action(actionType: NetworkDebuggerActions.self) {
                    action.action(.request(request)) {
                        [weak self]
                        returnedAction in
                        switch returnedAction {
                        case .request(let newRequest):
                            self?.sendRequest(request: newRequest, completion: {
                                [weak self ]
                                error, returnedData in
                                self?.processResponse(data: returnedData, error: error, continuation: continuation)
                            })
                            break
                        default:
                            break
                            
                        }
                    }
                }
            case .ignore:
                self?.sendRequest(request: request, completion: {
                    [weak self ]
                    error, returnedData in
                    self?.processResponse(data: returnedData, error: error, continuation: continuation)
                })
            }
        })
    }
    private func sendRequest(request: URLRequest, completion: @escaping (Error?, Data?) -> ()) {
        session.dataTask(with: request) { data, response, error in
            completion(error, data)
        }
    }
    private func processResponse(data: Data?, error: Error?, continuation: CheckedContinuation<Data, Error>) {
        if let data {
            continuation.resume(returning: data)
        }
        else if let error {
            continuation.resume(throwing: error)
        }else {
            continuation.resume(throwing: NetworkErrorCode.notFound)
        }
    }
}