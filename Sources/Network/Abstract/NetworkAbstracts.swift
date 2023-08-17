//
//  File.swift
//  
//
//  Created by Apple on 16/08/2023.
//

import Foundation
import core_architecture
public protocol NetworkingMode {
    var base: Servable { get }
}
public protocol Servable: Pointable & Headable {
    
}
public protocol Pointable {
    var pointing: String {get}
}
public protocol Headable {
    var headers: [String: String] {get}
}
/// NetworkRequestProviderProtocol
public protocol NetworkRequestProviderProtocol: Debugable {
    var authenticationType: NetworkAuthentication { get }
    var request: URLRequest? { get }
}
public protocol Responsable: DataModel {
    associatedtype DM: DataModel
    var code: Int {get set}
    var message: String {get set}
    var content: DM? {get set}
}

/// Networking Protocol
public protocol Networking: DataSourcing {
    associatedtype RequestProvider: NetworkRequestProviderProtocol
    // Generic Function for network api execution.
    func api<DM: Responsable>(requestProvider: RequestProvider, dataType: DM.Type, completion: @escaping (Result<DM, NetworkError>) -> ())
}
