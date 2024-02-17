//
//  File.swift
//  
//
//  Created by Apple on 28/11/2023.
//

import Foundation
import Core
import CoreUI
import Debugger
import Dependencies
public enum DebuggerViewFactoryInput {
case breakpoint, debug(NetworkDebuggerActions)
}
public enum DebuggerUIViewFactoryInput {
case data(NetworkDebuggerActions), request(NetworkDebuggerActions)
}
extension ViewFactory {
    public func swiftUIView(input: DebuggerViewFactoryInput) -> any SwiftUIView {
        switch input {
        case .breakpoint:
            return BreakpointConfigurationsModule(input: .init()).view()
        case .debug(let action):
            return NetworkDebugModule(input: action).view()
        }
    }
    public func swiftUIView(input: DebuggerUIViewFactoryInput) -> any SwiftUIView {
        switch input {
        case .data(let action):
            return DebugDataModule(input: .init(action: action)).view()
        case .request(let action):
            return NetworkDebugModule(input: action).view()
        }
    }
}

