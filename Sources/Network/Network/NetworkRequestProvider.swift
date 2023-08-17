//
//  NetworkRequestProvider.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 16/05/2023.
//

import Foundation
import core_architecture

struct NetworkRequestProvider<ENDPOINT: Pointable>: NetworkRequestProviderProtocol {    
    var networkMode: NetworkMode
    var endPoint: ENDPOINT
    var method: HttpMethod
    var data: DataModel?
    var authenticationType: NetworkAuthentication
    init(networkMode: NetworkMode, endPoint: ENDPOINT, method: HttpMethod = .get, data: DataModel? = nil, authenticationType: NetworkAuthentication = .none) {
        self.endPoint = endPoint
        self.method = method
        self.data = data
        self.authenticationType = authenticationType
        self.networkMode = networkMode
    }
    var request: URLRequest? {
        var urlRequest: URLRequest?
        
        var completeURLString = networkMode.base.pointing + endPoint.pointing
        switch method {
        case .get:
            print("URL: \(completeURLString)")
            if data != nil {
                if let param = data?.data?.dictionary()?.headersDictionary {
                    completeURLString += param.toURLString
                }
                else {
                    print("Unable to convert parameters into key-value")
                    return nil
                }
            }
            if let url = URL(string: completeURLString) {
                var request = URLRequest(url: url)
                request.httpMethod = method.rawValue
                urlRequest = request
            }
        case .post:
            print("URL: \(completeURLString)")
            if let url = URL(string: completeURLString) {
                var request = URLRequest(url: url)
                request.httpMethod = method.rawValue
                request.httpBody = data?.data
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest = request
            }
        }
        urlRequest?.allHTTPHeaderFields = networkMode.base.headers
        switch authenticationType {
        case .basic(_, _):
            // TODO: Implement Basic Auth
            break
        case .bearer(let token):
            if let token {
                urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        case .none:
            break
        }
        return urlRequest
    }
}
