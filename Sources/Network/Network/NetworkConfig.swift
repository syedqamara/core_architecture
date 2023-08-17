//
//  GeneralRequest.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 25/05/2023.
//

import Foundation
import core_architecture

public struct NetworkMode: NetworkingMode {
    public var base: Servable
}

public enum NetworkAuthentication {
    case basic(username: String, password: String), bearer(token: String?), none
}
public enum HttpMethod: String {
case get, post
    
    public var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

public enum NetworkError {
    case standard(NetworkErrorCode), custom(Error)
}
extension NetworkError: Erroring {
    public var code: Int {
        switch self {
        case .standard(let code):
            return code.code
        case .custom(let err):
            return (err as NSError).code
        }
    }
    public var message: String {
        switch self {
        case .standard(let code):
            return code.message
        case .custom(let err):
            return (err as NSError).description
        }
    }
    public var identifier: String {
        switch self {
        case .standard(let code):
            return code.identifier
        case .custom(let err):
            return (err as NSError).domain
        }
    }
}
