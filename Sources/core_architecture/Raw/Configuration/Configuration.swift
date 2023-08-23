//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation

public protocol ConfigID {
    var id: String { get }
}
public protocol ConfigStoring {
    func add<D: Configurable>(config: D)
    func remove<D: Configurable>(config: D)
    func find<D: Configurable>(id: ConfigID, to: D.Type) -> D?
}
public protocol Configurable {
    associatedtype Content
    var identifier: ConfigID { get }
    var content: Content { get }
}

public struct Config<C>: Configurable {
    public typealias Content = C
    
    public var identifier: ConfigID
    public var content: C
    public init(identifier: ConfigID, content: C) {
        self.identifier = identifier
        self.content = content
    }
}
public class ConfigurationStore: ConfigStoring {
    public static let shared = ConfigurationStore()
    private var storage: [String: any Configurable] = [:]
    private let queue = DispatchQueue(label: "com.configStoring.queue", attributes: .concurrent)
    private let logger: Logs<ConfigStoreLogAction> = .init(id: "com.configStoring.logs")
    init() {}

    public func add<D: Configurable>(config: D) {
        logger.log(config, action: .add)
        queue.async(flags: .barrier) {
            self.storage[config.identifier.id] = config
        }
    }

    public func remove<D: Configurable>(config: D) {
        logger.log(config, action: .remove)
        queue.async(flags: .barrier) {
            self.storage[config.identifier.id] = nil
        }
    }

    public func find<D: Configurable>(id: ConfigID, to: D.Type) -> D? {
        var result: D?
        queue.sync {
            result = storage[id.id] as? D
            logger.log(result, action: .remove)
        }
        return result
    }
}

@propertyWrapper
public struct ConfigStore<A> {
    private let id: ConfigID
    public init(_ id: ConfigID) {
        self.id = id
    }
    public var wrappedValue: A? {
        get {
            ConfigurationStore.shared.find(id: id, to: Config<A>.self)?.content
        }
        set {
            guard let config = newValue else { return }
            ConfigurationStore.shared.add(config: Config(identifier: id, content: config))
        }
    }
}



extension ConfigurationStore {
    enum ConfigStoreLogAction: LogAction {
    case add, remove, find
        var rawValue: String {
            switch self {
            case .add:
                return "Adding New Debug Config"
            case .remove:
                return "Removing New Debug Config"
            case .find:
                return "Finding New Debug Config"
            }
        }
    }
}

//let configStore = ConfigStore()

//let breakpointConfig = Config<BreakPoint>(identifier: <#T##ConfigID#>, content: <#T##BreakPoint#>)
//
//configStore.add(config: )
