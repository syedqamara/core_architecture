//
//  File.swift
//  
//
//  Created by Apple on 16/08/2023.
//

import Foundation
import ManagedAppConfigLib
import core_architecture

public protocol Debugable: Configurable {
    var debugID: String { get }
}


public enum BreakPointType: String, CaseIterable {
    case console, ignore
}
public protocol DebuggingAction: Debugable {
    
}
public protocol Debugging {
    func action<B: DebuggingAction>(actionType: B.Type) -> DebugAction<B>?
    func debug<D: Debugable, F: Debug>(debug: D, feature: F.Type) throws -> BreakPointType
}
public class Debug: Configurable {
    public var configID: String
    public var breakpoint: BreakPointType
    public required init(configID: String, breakpoint: BreakPointType) {
        self.configID = configID
        self.breakpoint = breakpoint
    }
    public var className: String { String(describing: Self.self) }
    public func toggle() {
        switch breakpoint {
        case .console:
            breakpoint = .ignore
        case .ignore:
            breakpoint = .console
        }
    }
}


public struct DebugAction<A> {
    public typealias ReactionCompletion = (A) -> ()
    public typealias ActionCompletion = (A, @escaping ReactionCompletion) -> ()
    public var action: ActionCompletion
    public init(action: @escaping ActionCompletion) {
        self.action = action
    }
    public static var noAction: DebugAction<A> { .init(action: { $1($0) }) }
}

open class Debugger<A: DebuggingAction>: Debugging {
    public var action: DebugAction<A>?
    public init(action: DebugAction<A>? = nil) {
        self.action = action
    }
    public func action<B>(actionType: B.Type) -> DebugAction<B>? where B : DebuggingAction {
        if let typedAction = action as? DebugAction<B> {
            return typedAction
        }
        return nil
    }
    public func debug<D, F>(debug: D, feature: F.Type) throws -> BreakPointType where D : Debugable, F : Debug {
        @Configuration(debug.debugID) var featureConfig: F?
        guard let config = featureConfig else {
            throw SystemError.debugger(.noConfigurationFound)
        }
        return config.breakpoint
    }
}
public class Continuation<A, B> {
    public typealias ACallback = (A) -> ()
    public typealias BCallback = (B) -> ()
    public init() {
        
    }
    fileprivate var a: ACallback?
    fileprivate var b: BCallback?
    
    public func onRecieving(a: ACallback?) {
        self.a = a
    }
    public func onThrowing(b: BCallback?) {
        self.b = b
    }
    
    public func resume(throwing: B) {
        if let b {
            b(throwing)
        }
    }
    public func resume(returning: A) {
        if let a {
            a(returning)
        }
    }
}
