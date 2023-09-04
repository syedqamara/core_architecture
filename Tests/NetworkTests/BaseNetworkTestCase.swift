//
//  NetworkBaseTestCase.swift
//  
//
//  Created by Apple on 25/08/2023.
//
import XCTest
import Foundation
import core_architecture
import ManagedAppConfigLib
@testable import Network

class NetworkBaseTestCase: XCTestCase {
    private let registrar: RegisteringSystem = .shared
    func register(completion: (RegisteringSystem) -> ([Registering])) {
        ConfigManager.shared.removeAll()
        let registers = completion(registrar)
        registers.forEach { XCTAssertTrue(!$0.isEmpty, "No Registration for \(String(describing: $0))") }
    }
    
    func sendNetworkRequest<N: Network>(action: DebugAction<NetworkDebuggerActions>, session: SessionManager, requestData: DataModel? = nil) -> NetworkManager<N> {
        let host = NetworkHost.default()
        let network = N(
            host: host,
            debugger: Debugger(action: action),
            session: session
        )
        return NetworkManager(network: network)
    }
    
}

