//
//  File.swift
//  
//
//  Created by Apple on 16/08/2023.
//

import Foundation

public protocol Debugable: ConfigID {
    
}
public enum DebugResult {
    case console, ignore
}
public protocol DebuggingAction {
    
}
public protocol Debugging {
    func action<B: DebuggingAction>(actionType: B.Type) -> DebugAction<B>?
    func debug<D: Debugable>(debug: D) -> DebugResult
}
public protocol ConsoleDebugging {
    func console<D: Debugable>(debug: D) -> DebugResult
}
public protocol IsEnable {
    var isEnabled: Bool { get }
}
public protocol EnableBreakpointable: IsEnable {}
public protocol EnableDebugConsolable: IsEnable {}

// Apply this to request or response object


public struct EnableBreakPoint: EnableBreakpointable {
    public var isEnabled: Bool
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}
public struct EnableDebugConsole: EnableDebugConsolable {
    public var isEnabled: Bool
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}

public struct AsyncAction<A> {
    public typealias ActionCompletion = (A) -> ()
    public var action: ActionCompletion
    public init(action: @escaping ActionCompletion) {
        self.action = action
    }
}

public struct DebugAction<A> {
    public typealias ActionCompletion = (A, (A) -> ()) -> ()
    public var action: ActionCompletion
    public init(action: @escaping ActionCompletion) {
        self.action = action
    }
}
open class Debugger<A: DebuggingAction>: Debugging {
    
    
    public var action: DebugAction<A>
    public init(action: DebugAction<A>) {
        self.action = action
    }
    public func action<B>(actionType: B.Type) -> DebugAction<B>? where B : DebuggingAction {
        if let typedAction = action as? DebugAction<B> {
            return typedAction
        }
        return nil
    }
    public func debug<D>(debug: D) -> DebugResult where D : Debugable {
        @ConfigStore<EnableBreakPoint>(debug) var breakPointConfig
        guard let config = breakPointConfig else {
            fatalError("No Debug Breakpoint Configuration Found")
        }
        if config.isEnabled {
            return console(debug: debug)
        }
        return .ignore
    }
    public func console<D>(debug: D) -> DebugResult where D : Debugable {
        @ConfigStore<EnableDebugConsole>(debug) var debugConsoleConfig
        guard let config = debugConsoleConfig else {
            fatalError("No Debug Console Configuration Found")
        }
        if config.isEnabled {
            return .console
        }
        return .ignore
    }
}
