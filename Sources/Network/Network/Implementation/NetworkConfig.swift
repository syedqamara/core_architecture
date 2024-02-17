//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Core

public enum NetworkCachePolicy: String {
    case noCache
    case cacheWhenNoNetwork
    case cacheEveryTime
}

public struct NetworkConfig: Configurable {
    public var configID: String { "\(id)" }
    public let id: TimeInterval = Date().timeIntervalSince1970
    public let name: String
    public let host: Hosting?
    public let to: Pointable
    public let method: HTTPMethod
    public let contentType: ContentType
    public let responseType: DataModelProtocol.Type
    public let cachePolicy: NetworkCachePolicy
    public let headers: [String: String]
    public init(name: String, host: Hosting?, to: Pointable, method: HTTPMethod, contentType: ContentType, responseType: DataModelProtocol.Type, cachePolicy: NetworkCachePolicy, headers: [String: String]) {
        self.name = name
        self.host = host
        self.to = to
        self.method = method
        self.contentType = contentType
        self.responseType = responseType
        self.cachePolicy = cachePolicy
        self.headers = headers
    }
    public init(config: NetworkConfig, to: Pointable) {
        self.name = config.name
        self.host = config.host
        self.to = to
        self.method = config.method
        self.contentType = config.contentType
        self.responseType = config.responseType
        self.cachePolicy = config.cachePolicy
        self.headers = config.headers
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
extension NetworkConfig {
    var url: URL? {
        if let host {
            return URL(string: "\(host.hostScheme)/\(to.pointing)")
        }
        return URL(string: to.pointing)
    }
}
extension NetworkConfig {
    private enum __Preview__Endpoint__: String, Pointable {
        case no, no1, no2
        
        var pointing: String { rawValue }
        var debugID: String { rawValue }
        var configID: String { rawValue }
        
        static var allCases: [NetworkConfig.__Preview__Endpoint__] = []
        
    }
    public struct __Preview_Data__Model: DataModel {
        
    }
    public static var preview: NetworkConfig {
        .init(
            name: "Preview Api",
            host: NetworkHost.localHost,
            to: __Preview__Endpoint__.no,
            method: .get,
            contentType: .applicationJSON,
            responseType: __Preview_Data__Model.self,
            cachePolicy: .noCache,
            headers: [
                "static_header": "No"
            ]
        )
    }
    public static var preview1: NetworkConfig {
        .init(
            name: "Preview-1 Api",
            host: NetworkHost.localHost,
            to: __Preview__Endpoint__.no1,
            method: .get,
            contentType: .applicationJSON,
            responseType: __Preview_Data__Model.self,
            cachePolicy: .noCache,
            headers: [
                "static_header": "No 1"
            ]
        )
    }
    public static var preview2: NetworkConfig {
        .init(
            name: "Preview-2 Api",
            host: NetworkHost.localHost,
            to: __Preview__Endpoint__.no2,
            method: .get,
            contentType: .applicationJSON,
            responseType: __Preview_Data__Model.self,
            cachePolicy: .noCache,
            headers: [
                "static_header": "No 1"
            ]
        )
    }
}

public enum ImageEndpoint {
    case image(url: String)
}

extension ImageEndpoint: Pointable {
    public var pointing: String {
        switch self {
        case .image(url: let url):
            return url
        }
    }
    
    static public var allCases: [ImageEndpoint] {
        []
    }
    
    public var debugID: String {
        "image"
    }
    
    public var configID: String {
        "image"
    }
    
    
}
