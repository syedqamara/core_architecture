//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Core
import Debugger

public protocol Pointable: Enpointable {
    var pointing: String { get }
    static var allCases: [Self] { get }
}

public protocol Hosting {
    var scheme: String { get }
    var host: String { get }
    var port: Int { get }
    var path: String { get }
}

extension Hosting {
    public var hostScheme: String {
        // TODO: Implement port
        scheme + "://" + host + "/" + path
    }
}

public protocol SessionTask {
    func resume()
}

public protocol SessionManager {
    func task(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> SessionTask?
}


public protocol Networking {
    func send(with data: DataModel?, config: NetworkConfig) async throws -> DataModelProtocol
}
public protocol NetworkRequestEncoding {
    func encode(data: DataModel?) async throws -> String?
}

public protocol ManagableNetworking {
    func send<D: DataModelProtocol>(to: Pointable, with data: DataModel?, type: D.Type) async throws -> D
}

public protocol EncodingProtocol {
    func encode(data: DataModelProtocol) throws -> Data
}
public protocol DecodingProtocol {
    func decode<D: DataModelProtocol>(data: Data, type: D.Type) throws -> D
}
