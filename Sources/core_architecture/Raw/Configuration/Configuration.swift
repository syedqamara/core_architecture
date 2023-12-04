//
//  File.swift
//  
//
//  Created by Apple on 24/08/2023.
//

import Foundation

public protocol Configurable {
    var configID: String { get }
}

public final class ConfigManager {
    public static let shared = ConfigManager()
    private var configDictionary: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.configManager.queue", attributes: .concurrent)

    subscript<T>(key: String) -> T? {
        get {
            return queue.sync {
                return configDictionary[key] as? T
            }
        }
        set {
            queue.sync(flags: .barrier) {
                self.configDictionary[key] = newValue
            }
        }
    }
    public func search<T>(type: T.Type) -> [T]{
        return queue.sync {
            var configurations: [T] = []
            for config in configDictionary {
                if let typeConfig = config.value as? T {
                    configurations.append(typeConfig)
                }
            }
            return configurations
        }
    }
    public func removeAll() {
        queue.async(flags: .barrier) {
            self.configDictionary = [:]
        }
    }
}

@propertyWrapper
public struct Configuration<A> {
    private let key: String
    private let manager: ConfigManager = .shared
    public init(_ key: String) {
        let finalKey = key + "_" + String(describing: A.self)
        self.key = finalKey
    }
    fileprivate var applyingKey: String {
        return key + String(describing: A.self)
    }
    public var wrappedValue: A? {
        get {
            return manager[applyingKey]
        }
        set {
            manager[applyingKey] = newValue
        }
    }
}
@propertyWrapper
public struct Configurations<A> {
    private let manager: ConfigManager = .shared
    private let type: A.Type?
    public init(_ type: A.Type? = nil) {
        self.type = type
    }
    public var wrappedValue: [A] {
        get {
            return manager.search(type: self.type ?? A.self)
        }
    }
}
