//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import core_architecture

public struct NetworkConfig {
    public let host: Hosting
    public let to: Pointable
    public let method: HTTPMethod
    public let contentType: ContentType
    public let responseType: DataModel.Type
    public let headers: [String: String]
    public init(host: Hosting, to: Pointable, method: HTTPMethod, contentType: ContentType, responseType: DataModel.Type, headers: [String: String]) {
        self.host = host
        self.to = to
        self.method = method
        self.contentType = contentType
        self.responseType = responseType
        self.headers = headers
    }
}
public enum HTTPMethod: String {
case get, post, put
    public var rawValue: String {
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
public enum ContentType: String {
    case queryParam, postFormData, applicationJSON
    
    public var rawValue: String {
        switch self {
        case .queryParam:
            return ""
        case .postFormData:
            return "url-form-encoded"
        case .applicationJSON:
            return "application/json"
        }
    }
    public var encoder: NetworkRequestEncoding {
        switch self {
        case .queryParam:
            return GetNetworkRequestEncoder()
        case .postFormData:
            return PostFormNetworkRequestEncoder()
        case .applicationJSON:
            return PostJSONNetworkRequestEncoder()
        }
    }
}
