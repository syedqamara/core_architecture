//
//  NetworkDependencyKeys.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import Dependencies

public typealias DefaultNetworkManager = NetworkManager<Network>

extension DefaultNetworkManager: TestDependencyKey, DependencyKey {
    public static var liveValue: NetworkManager<Network> {
        .init(
            network: Network(
                session: URLSession.shared
            )
        )
    }
    public static var testValue: NetworkManager<Network> {
        .init(
            network: Network(
                session: URLSession.shared
            )
        )
    }
}
