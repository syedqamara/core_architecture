//
//  File.swift
//  
//
//  Created by Apple on 27/08/2023.
//

import Foundation
import core_architecture

public class DebugConnection<A: DebuggingAction>: ViewModeling {
    weak private var debugger: Debugger<A>? {
        didSet {
            setupAction()
        }
    }
    private var reactionCompletion: DebugAction<A>.ReactionCompletion?
    @Published public var debuggingAction: A?
    public init(debugger: Debugger<A>?) {
        self.debugger = debugger
        setupAction()
    }
    private func setupAction() {
        self.debugger?.action = .init(
            action: {
                [weak self]
                action, reaction in
                DispatchQueue.main.async {
                    self?.debuggingAction = action
                    self?.reactionCompletion = reaction
                }
            }
        )
    }
    public func sendReaction(action: A) {
        if let reactionCompletion {
            reactionCompletion(action)
        }
    }
}

public class NetworkDebugConnectionViewModel: DebugConnection<NetworkDebuggerActions> {
    
}
