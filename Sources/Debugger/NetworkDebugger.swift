//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation
import ManagedAppConfigLib
import core_architecture

public typealias NetworkDebugger = Debugger<NetworkDebuggerActions>

public struct NetworkDebuggerActions: DebuggingAction, ModulingInput, Identifiable {
    public var id: String = "\(Date().timeIntervalSince1970)"
    public var configID: String
    public var debugID: String
    public var debugData: NetworkDebuggers
    public init(configID: String, debugID: String, debugData: NetworkDebuggers) {
        self.configID = configID
        self.debugID = debugID
        self.debugData = debugData
    }
}
public enum NetworkDebuggers {
    case request(URLRequest), data(DataModel, DataModel.Type), error(Error), response(URLResponse)
}

public enum DebugModuleInputs {
    case debug(NetworkDebuggerActions)
}

public protocol Enpointable: Debugable, Configurable {
    
}

public final class NetworkRequestDebug: Debug {}
public final class NetworkDataDebug: Debug {}
public final class NetworkResponseDebug: Debug {}
public final class NetworkErrorDebug: Debug {}

public var kAllDebuggers = [NetworkRequestDebug.self, NetworkDataDebug.self, NetworkResponseDebug.self, NetworkErrorDebug.self]
