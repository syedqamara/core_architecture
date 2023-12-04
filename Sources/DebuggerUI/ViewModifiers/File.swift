//
//  File.swift
//  
//
//  Created by Apple on 28/11/2023.
//

import Foundation
import SwiftUI
import Debugger
import Dependencies

public enum ApplicationDebugCommands: String, CustomStringConvertible, CaseIterable {
case application, breakpoint
    public var description: String {
        switch self {
        case .application:
            return "Application"
        case .breakpoint:
            return "Breakpoint"
        }
    }
    public var shortcut: String {
        switch self {
        case .application:
            return "A"
        case .breakpoint:
            return "B"
        }
    }
}


public struct DebugShakeGestureModifier: ViewModifier {
    @Binding var selectedCommand: ApplicationDebugCommands
    @State var isShowing: Bool = false
    @State var networkDebugAction: NetworkDebuggerActions?
    @Dependency(\.networkDebugConnection) var networkDebugConnection
    @Dependency(\.viewFactory) var viewFactory
    public init(selectedCommand: Binding<ApplicationDebugCommands>, isShowing: Bool = false, networkDebugAction: NetworkDebuggerActions? = nil) {
        _selectedCommand = selectedCommand
        self.isShowing = isShowing
        self.networkDebugAction = networkDebugAction
    }
    public func body(content: Content) -> some View {
        content
            .onShakeGesture {
                switch selectedCommand {
                case .application:
                    selectedCommand = .breakpoint
                case .breakpoint:
                    selectedCommand = .application
                }
            }
            .sheet(isPresented: $isShowing, content: {
                if let networkDebugAction {
                    self.debugView(action: networkDebugAction)
                }
            })
            .onReceive(networkDebugConnection.$debuggingAction) { debuggingAction in
                guard let action: NetworkDebuggerActions = debuggingAction else { return }
                self.networkDebugAction = action
            }
    }
    private func debugView(action: NetworkDebuggerActions) -> some View {
        AnyView(
            viewFactory.makeView(
                input: .debug(action)
            )
        )
        .environmentObject(networkDebugConnection)
    }
    
}
