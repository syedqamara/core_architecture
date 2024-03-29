//
//  BreakpointConfigurationsViewModel.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import Foundation
import Core
import Debugger
import Network
import SwiftUI

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
        return networkConfigurations.sorted { prev, next in
            prev.id < next.id
        }
    }
    func debuggers(for id: String) -> [Debug] {
        @Configuration<NetworkRequestDebug>(id) var request
        @Configuration<NetworkDataDebug>(id) var data
        @Configuration<NetworkResponseDebug>(id) var response
        @Configuration<NetworkErrorDebug>(id) var error
        return [request, data, response, error].compactMap { $0 }
    }
    func toggleBreakpoint(for id: String, className: String) {
        @Configuration<NetworkRequestDebug>(id) var request
        @Configuration<NetworkDataDebug>(id) var data
        @Configuration<NetworkResponseDebug>(id) var response
        @Configuration<NetworkErrorDebug>(id) var error
        
        if request?.className == className {
            request?.toggle()
        } else if data?.className == className {
            data?.toggle()
        } else if response?.className == className {
            response?.toggle()
        } else if error?.className == className {
            error?.toggle()
        }
        objectWillChange.send()
    }
}
