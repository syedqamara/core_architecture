//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import core_architecture

public class NetworkManager<N: Network>: ManagableNetworking {
    private let network: N
    public init(network: N) {
        self.network = network
    }
    public func send<D>(to: Pointable, with data: DataModel?, type: D.Type) async throws -> D where D : DataModel {
        @Configuration(to.configID) var configuration: NetworkConfig?
        if var staticConfiguration = configuration {
            let config = NetworkConfig(config: staticConfiguration, to: to)
            let result = try await network.send(with: data, config: config)
            if let decodedResult = result as? D {
                return decodedResult
            } else if let rawData = result.data {
                return try JSONDecoder().decode(type, from: rawData)
            }else {
                throw SystemError.network(.invalidSwiftModel)
            }
        }
        else {
            throw SystemError.network(.noNetworkConfigurationFound)
        }
    }
}
