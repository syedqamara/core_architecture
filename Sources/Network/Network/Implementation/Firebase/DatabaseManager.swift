//
//  File.swift
//  
//
//  Created by Apple on 17/02/2024.
//

import Foundation
import Core

public class DatabaseNetworkManager<N: DatabaseNetwork>: ManagableNetworking {
    private let network: N
    public init(network: N) {
        self.network = network
    }
    public func send<D>(to: Pointable, with data: DataModel?, type: D.Type) async throws -> D where D : DataModelProtocol {
        @Configuration(to.configID) var configuration: DatabaseConfig?
        if let staticConfiguration = configuration {
            let config = DatabaseConfig(config: staticConfiguration, to: to)
            let result = try await network.send(with: data, config: config)
            if let decodedResult = result as? D {
                return decodedResult
            } else {
                throw SystemError.network(.invalidSwiftModel)
            }
        }
        else {
            throw SystemError.network(.noNetworkConfigurationFound)
        }
    }
}
