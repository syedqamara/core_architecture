//
//  DebuggerKeys.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Dependencies

extension NetworkDebugger: TestDependencyKey, DependencyKey {
    public static var liveValue: NetworkDebugger {
        .init()
    }
    public static var testValue: NetworkDebugger {
        .init()
    }
}

extension NetworkDebugConnectionViewModel: TestDependencyKey, DependencyKey {
    public static var liveValue: NetworkDebugConnectionViewModel {
        @Dependency(\.networkDebugger) var debugger
        return .init(debugger: debugger)
    }
}
