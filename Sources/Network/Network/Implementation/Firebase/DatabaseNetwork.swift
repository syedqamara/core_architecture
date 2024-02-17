//
//  DatabaseNetwork.swift
//  
//
//  Created by Apple on 17/02/2024.
//

import Foundation
import Core
import Dependencies
import Debugger
import Combine

public protocol NetworkService {
    
}

public protocol CreateService: NetworkService {
    func create<D: DataModelProtocol>(_ data: D, to: Pointable) async throws
}
public protocol FetchService: NetworkService {
    func fetch<D: DataModelProtocol>(type: D.Type, to: Pointable) async throws -> D
}
public protocol DeleteService: NetworkService {
    func delete<D: DataModelProtocol>(_ data: D, to: Pointable) async throws
}
public protocol UpdateService: NetworkService {
    func update<D: DataModelProtocol>(_ data: D, to: Pointable) async throws
}


public protocol DatabaseService: CreateService, FetchService, DeleteService, UpdateService {
    
}

public class DatabaseNetwork: Networking {
    public typealias NetworkConfigType = DatabaseConfig
    private let service: any DatabaseService
    @Dependency(\.networkDebugger) var debugger
    public init(service: any DatabaseService) {
        self.service = service
    }
    public func send(with data: DataModel?, config: DatabaseConfig) async throws -> DataModelProtocol {
        let result = try await _send(with: data, config: config)
        
        let continuation = Continuation<DataModelProtocol, Error>()
        
        
        return try await withCheckedThrowingContinuation { cont in
            continuation.onRecieving { data in
                cont.resume(returning: data)
            }
            continuation.onThrowing { error in
                cont.resume(throwing: error)
            }
            
            self.debugger.debugData(config: config.to, type: config.responseType, data: result, continuation: continuation)
        }
    }
    private func _send(with data: DataModel?, config: DatabaseConfig) async throws -> DataModelProtocol {
        switch config.operation {
        case .create:
            if let data {
                try await service.create(data, to: config.to)
                return data
            }
            else {
                throw SystemError.network(.unprocessableEntity)
            }
        case .read:
            let result = try await service.fetch(type: config.responseType, to: config.to)
            return result
        case .update:
            if let data {
                try await service.update(data, to: config.to)
                return data
            }
            else {
                throw SystemError.network(.unprocessableEntity)
            }
        case .delete:
            if let data {
                try await service.delete(data, to: config.to)
                return data
            }
            else {
                throw SystemError.network(.unprocessableEntity)
            }
        }
    }
    
    
}
