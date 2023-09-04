//
//  BreakpointConfigurationsViewModel.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import Foundation
import core_architecture
import Debugger
import Network

public enum DebugConfigurations: Identifiable {
    case request(NetworkRequestDebug), data(NetworkDataDebug), response(NetworkResponseDebug), error(NetworkErrorDebug)
    init?(_ debug: Debug) {
        if let debugConcrete = debug as? NetworkRequestDebug {
            self = .request(debugConcrete)
        }
        else if let debugConcrete = debug as? NetworkDataDebug {
            self = .data(debugConcrete)
        }
        else if let debugConcrete = debug as? NetworkResponseDebug {
            self = .response(debugConcrete)
        }
        else if let debugConcrete = debug as? NetworkErrorDebug {
            self = .error(debugConcrete)
        }
        else {
            return nil
        }
    }
    public var id: String {
        switch self {
        case .request(let networkRequestDebug):
            return "request: " + networkRequestDebug.configID
        case .data(let networkDataDebug):
            return "data: " + networkDataDebug.configID
        case .response(let networkResponseDebug):
            return "response: " + networkResponseDebug.configID
        case .error(let networkErrorDebug):
            return "error: " + networkErrorDebug.configID
        }
    }
}

public class BreakpointConfigurationsViewModel: ViewModeling {
    
    func networks() -> [NetworkConfig] {
        @Configurations(NetworkConfig.self) var networkConfigurations
        return networkConfigurations
    }
    
    func debuggers() -> [String] {
        return kAllDebuggers.map { String(describing: $0) }
    }
    func selectedDebuggerConfigurations(debugger: String) -> [Debug] {
        guard let selected = kAllDebuggers.filter({ String(describing: $0) == debugger }).first else {
            return []
        }
        @Configurations(selected) var breakpointConfigurations
        return breakpointConfigurations.filter { $0.className == debugger }
    }
    
}
