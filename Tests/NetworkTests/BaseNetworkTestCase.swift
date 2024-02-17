//
//  NetworkBaseTestCase.swift
//  
//
//  Created by Apple on 25/08/2023.
//
import XCTest
import Foundation
import Core
import ManagedAppConfigLib
import Dependencies
@testable import Network
import Debugger

class NetworkBaseTestCase: XCTestCase {
    @Dependency(\.registerar) var registrar
//    private let registrar: RegisteringSystem = .shared
    func register(completion: (RegisteringSystem) -> ([Registering])) {
        ConfigManager.shared.removeAll()
        let registers = completion(registrar)
        registers.forEach { XCTAssertTrue(!$0.isEmpty, "No Registration for \(String(describing: $0))") }
    }
    
    func sendNetworkRequest<N: Network>(action: DebugAction<NetworkDebuggerActions>, session: SessionManager, requestData: DataModel? = nil) -> NetworkManager<N> {
        let host = NetworkHost.default()
        let network = N(
            session: session,
            encoder: JSONCoding(),
            decoder: JSONCoding()
        )
        return NetworkManager(network: network)
    }
    
}

