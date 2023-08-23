//
//  File.swift
//  
//
//  Created by Apple on 16/08/2023.
//

import Foundation
import ManagedAppConfigLib


public protocol Debugable {
    var id: String { get }
}

extension Debugable {
    func register<D: Debug>(type: D.Type) {
        @AppConfig(self.id) var config: D = D(result: .console)
    }
}


public enum DebugResult {
    case console, ignore
}
public protocol DebuggingAction {
    
}
public protocol Debugging {
    func action<B: DebuggingAction>(actionType: B.Type) -> DebugAction<B>?
    func debug<D: Debugable, F: Debug>(debug: D, feature: F.Type) -> DebugResult
}
public class Debug {
    public var result: DebugResult
    public required init(result: DebugResult) {
        self.result = result
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
    public func debug<D, F>(debug: D, feature: F.Type) -> DebugResult where D : Debugable, F : Debug {
        @AppConfig(debug.id) var featureConfig: F?
        guard let config = featureConfig else {
            fatalError("No Debug Console Configuration Found")
        }
        return config.result
    }
}
