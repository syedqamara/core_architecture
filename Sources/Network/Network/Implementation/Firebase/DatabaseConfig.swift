//
//  FirebaseConfig.swift
//  
//
//  Created by Apple on 17/02/2024.
//

import Foundation
import Core

public struct DatabaseConfig: Configurable {
    public enum DatabaseOperation {
    case create, read, update, delete
    }
    
    public var configID: String { "\(id)" }
    public let id: TimeInterval = Date().timeIntervalSince1970
    public let name: String
    public let db: String?
    public let to: Pointable
    public let operation: DatabaseOperation
    public let responseType: DataModelProtocol.Type
    public let cachePolicy: NetworkCachePolicy
    public init(name: String, db: String?, to: Pointable, operation: DatabaseOperation, responseType: DataModelProtocol.Type, cachePolicy: NetworkCachePolicy) {
        self.name = name
        self.db = db
        self.to = to
        self.operation = operation
        self.responseType = responseType
        self.cachePolicy = cachePolicy
    }
    public init(config: DatabaseConfig, to: Pointable) {
        self.name = config.name
        self.db = config.db
        self.to = to
        self.operation = config.operation
        self.responseType = config.responseType
        self.cachePolicy = config.cachePolicy
    }
}
