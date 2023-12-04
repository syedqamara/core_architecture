//
//  File.swift
//  
//
//  Created by Apple on 28/11/2023.
//

import Foundation
import core_architecture
import Debugger
import Dependencies
public enum DebuggerViewFactoryInput {
case breakpoint, debug(NetworkDebuggerActions)
}
extension SwiftUIViewFactory {
    public func makeView(input: DebuggerViewFactoryInput) -> any SwiftUIView {
        switch input {
        case .breakpoint:
            return BreakpointConfigurationsModule(input: .init()).view()
        case .debug(let action):
            return NetworkDebugModule(input: action).view()
        }
    }
}
extension SwiftUIViewFactory: DependencyKey, TestDependencyKey {
    public static var liveValue: SwiftUIViewFactory = SwiftUIViewFactory()
    public static var testValue: SwiftUIViewFactory = SwiftUIViewFactory()
}

public extension DependencyValues {
    var viewFactory: SwiftUIViewFactory {
        get {
            self[SwiftUIViewFactory.self]
        }
        set {
            self[SwiftUIViewFactory.self] = newValue
        }
    }
}
