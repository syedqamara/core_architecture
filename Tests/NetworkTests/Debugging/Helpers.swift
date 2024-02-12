//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Network
import Core
extension NetworkHost {
    static func `default`() -> NetworkHost {
        .init(
            scheme: "https",
            host: "www.google.com",
            port: 8080,
            path: "api/v1"
        )
    }
}

struct MockSessionManager: SessionManager {
    var data: DataModel?
    init(data: DataModel? = nil) {
        self.data = data
    }
    func task(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionTask? {
        completionHandler(data?.data, nil, nil)
        return nil
    }
}

struct MockErrorSessionManager: SessionManager {
    let error: SystemError
    init(error: SystemError) {
        self.error = error
    }
    func task(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionTask? {
        completionHandler(nil, nil, error)
        return nil
    }
}
enum Endpoint {
    case login(isSocial: Bool), signup
}

extension Endpoint: Pointable {
    var debugID: String { "debugging.id.\(pointing)" }
    
    var configID: String { "configuration.id.\(pointing)" }
    
    static var allCases: [Endpoint] {
        [
            .login(isSocial: false),
            .login(isSocial: true),
            .signup
        ]
    }
    
    var pointing: String {
        switch self {
        case .login(let isSocial):
            if isSocial {
                return "login?is_social=true"
            }
            return "login?is_social=false"
        case .signup:
            return "signup"
        }
    }
}
struct LoginRequest: DataModel {
    var email: String
    var password: String
}
struct User: DataModel {
    var id: String
    var name: String
    
    func isEqual(to: User) -> Bool {
        id == to.id && name == to.name
    }
    
    static var testExample: User { User(id: "123", name: "Qamar") }
    static var testExample2: User { User(id: "123", name: "Qamar") }
}

