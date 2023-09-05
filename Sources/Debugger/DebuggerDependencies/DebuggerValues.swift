//
//  DebuggerValues.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Dependencies

extension DependencyValues {
    public var networkDebugger: NetworkDebugger {
        get { self[NetworkDebugger.self] }
        set { self[NetworkDebugger.self] = newValue }
    }
    public var networkDebugConnection: NetworkDebugConnectionViewModel {
        get { self[NetworkDebugConnectionViewModel.self] }
        set { self[NetworkDebugConnectionViewModel.self] = newValue }
    }
}

