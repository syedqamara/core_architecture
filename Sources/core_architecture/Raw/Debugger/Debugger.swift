//
//  File.swift
//  
//
//  Created by Apple on 16/08/2023.
//

import Foundation

public protocol Debugable {
    var data: DataModel? { get }
}
public enum DebugResult {
    case ignore, stop, debug(DebugingID)
}
public protocol DebugingID {
    var id: String { get }
}
public protocol Debuging {
    func debug<D: Debugable, I: DebugingID>(identifier: I, debug: D) -> DebugResult
}
public protocol DebugStoring {
    func add<D: DebugingConfig>(config: D)
    func remove<D: DebugingConfig>(config: D)
    func find<D: DebugingConfig>(id: DebugingID, to: D.Type) -> D?
}
public protocol DebugingConfig {
    associatedtype BreakPointType: Breakpointable
    var identifier: DebugingID { get }
    var breakPoint: BreakPointType { get }
}

public protocol Breakpointable {
    var isEnabled: Bool { get }
}

// Apply this to request or response object


public struct BreakPoint: Breakpointable {
    public var isEnabled: Bool
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}

public struct DebugConfig<BP: Breakpointable>: DebugingConfig {
    public typealias BreakPointType = BP
    public var identifier: DebugingID
    public var breakPoint: BP
    public init(identifier: DebugingID, breakPoint: BP) {
        self.identifier = identifier
        self.breakPoint = breakPoint
    }
}

public class SynchronizedDebugStore: DebugStoring {
    public static let shared = SynchronizedDebugStore()
    private var storage: [String: any DebugingConfig] = [:]
    private let queue = DispatchQueue(label: "com.debugStoring.queue", attributes: .concurrent)
    private let logger: Logs<SynchronizedDebugStoreLogAction> = .init(id: "com.debugStoring.logs")
    private init() {}

    public func add<D: DebugingConfig>(config: D) {
        logger.log(config, action: .add)
        queue.async(flags: .barrier) {
            self.storage[config.identifier.id] = config
        }
    }

    public func remove<D: DebugingConfig>(config: D) {
        logger.log(config, action: .remove)
        queue.async(flags: .barrier) {
            self.storage[config.identifier.id] = nil
        }
    }

    public func find<D: DebugingConfig>(id: DebugingID, to: D.Type) -> D? {
        var result: D?
        queue.sync {
            result = storage[id.id] as? D
            logger.log(result, action: .remove)
        }
        return result
    }
}

extension SynchronizedDebugStore {
    enum SynchronizedDebugStoreLogAction: LogAction {
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
