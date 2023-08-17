//
//  File.swift
//  
//
//  Created by Apple on 16/08/2023.
//

import Foundation
import core_architecture
//NetworkRequestProviderProtocol

typealias NetworkDebugConfig = DebugConfig<BreakPoint>

class NetworkDebugger: Debuging {
    func debug<D, I>(identifier: I, debug: D) -> DebugResult where D : Debugable, I : DebugingID {
        guard let debugConfig = SynchronizedDebugStore.shared.find(id: identifier, to: NetworkDebugConfig.self) else {
            fatalError("Implement Specialise function in `\(self.self)`")
        }
        if debugConfig.breakPoint.isEnabled {
            return .debug(identifier)
        }
        return .ignore
    }
}
