//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Core

public protocol DebuggingRegistering: Registering {
    init<D: Debug>(type: D.Type, debugable: Debugable, breakPoint: BreakPointType)
}


public struct DebuggerRegisteration: DebuggingRegistering {
    public var id: String
    public init<D>(type: D.Type, debugable: Debugable, breakPoint: BreakPointType) where D : Debug {
        self.id = debugable.debugID
        @Configuration(debugable.debugID) var config: D?
        config = D(configID: debugable.configID, breakpoint: breakPoint)
    }
}
