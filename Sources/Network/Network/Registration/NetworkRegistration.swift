//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Core
import Debugger
//NetworkConfig(to: endpoint, method: .post, contentType: .applicationJSON, responseType: User.self)

public protocol NetworkingConfigRegistering: Registering {
    init(name: String, host: Hosting?, endpoint: Pointable, method: HTTPMethod, contentType: ContentType, responseType: DataModelProtocol.Type, cachePolicy: NetworkCachePolicy, headers: [String : String])
}

public struct NetworkConfigRegisteration: NetworkingConfigRegistering {
    public var id: String
    public init(name: String, host: Hosting?, endpoint: Pointable, method: HTTPMethod, contentType: ContentType, responseType: DataModelProtocol.Type, cachePolicy: NetworkCachePolicy, headers: [String : String]) {
        self.id = endpoint.configID
        @Configuration(endpoint.configID) var configuration: NetworkConfig?
        configuration = NetworkConfig(
            name: name,
            host: host,
            to: endpoint,
            method: method,
            contentType: contentType,
            responseType: responseType,
            cachePolicy: cachePolicy,
            headers: headers
        )
    }
}

extension RegisteringSystem {
    // MARK: Debug Registration
    public func debuggerRegister<D: Debug>(type: D.Type, debugable: Debugable, breakPoint: BreakPointType) -> DebuggingRegistering {
        DebuggerRegisteration(
            type: type,
            debugable: debugable,
            breakPoint: breakPoint
        )
    }
    public func debuggerRegisterBatch(for endpoints: [Pointable], debugTypes types: [Debug.Type], breakpoints breakPoints: [BreakPointType]) -> [DebuggingRegistering] {
        guard endpoints.count == breakPoints.count && endpoints.count == types.count else {
            return []
        }
        var registeries: [DebuggingRegistering] = []
        for i in 0..<endpoints.count {
            let reg = self.debuggerRegister(type: types[i], debugable: endpoints[i], breakPoint: breakPoints[i])
            registeries.append(reg)
        }
        return registeries
    }
    
    // MARK: Network Config Registration
    public func networkRegister(name: String,
                         host: Hosting?,
                         endpoint: Pointable,
                         method: HTTPMethod,
                         contentType: ContentType,
                         responseType: DataModelProtocol.Type,
                         cachePolicy: NetworkCachePolicy,
                         headers: [String : String]) throws {
        let networkRegister = NetworkConfigRegisteration(
            name: name,
            host: host,
            endpoint: endpoint,
            method: method,
            contentType: contentType,
            responseType: responseType,
            cachePolicy: cachePolicy,
            headers: headers
        )
        let requestDebugRegister = debuggerRegister(type: NetworkRequestDebug.self, debugable: endpoint, breakPoint: .ignore)
        let dataDebugRegister = debuggerRegister(type: NetworkDataDebug.self, debugable: endpoint, breakPoint: .ignore)
        let errorDebugRegister = debuggerRegister(type: NetworkErrorDebug.self, debugable: endpoint, breakPoint: .ignore)
        let registers: [Registering] = [networkRegister, requestDebugRegister, dataDebugRegister, errorDebugRegister]
        guard registers.filter({ $0.isEmpty }).isEmpty else {
            throw SystemError.registration(.noConfigurationFound)
        }
    }
    public func networkRegisterBatch<P: Pointable>(pointType: P.Type, name: String, host: Hosting, endpoints: [P],
                         methods: [HTTPMethod],
                         contentTypes: [ContentType],
                         responseTypes: [DataModelProtocol.Type],
                         cachePolicies: [NetworkCachePolicy],
                         headers: [[String : String]]) throws {
        guard endpoints.count == methods.count,
              endpoints.count == contentTypes.count,
              endpoints.count == responseTypes.count,
              endpoints.count == cachePolicies.count,
              endpoints.count == headers.count else {
            throw SystemError.registration(.unEqualConfigurationProvided)
        }
        for i in 0..<endpoints.count {
            try networkRegister(
                name: name,
                host: host,
                endpoint: endpoints[i],
                method: methods[i],
                contentType: contentTypes[i],
                responseType: responseTypes[i],
                cachePolicy: cachePolicies[i],
                headers: headers[i]
            )
        }
    }
}
