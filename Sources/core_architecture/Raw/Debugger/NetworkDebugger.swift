//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation
import ManagedAppConfigLib
public enum NetworkDebuggerActions: DebuggingAction, ModulingInput {
    case request(URLRequest), data(DataModel, DataModel.Type), error(Error), response(URLResponse)
}

public enum DebugModuleInputs {
    case debug(NetworkDebuggerActions)
}

public protocol NetworkDebugable: Debugable {
    
}

extension NetworkDebugable {
    public var networkRequestDebugType: Debug.Type { NetworkRequestDebug.self }
    public var networkDataDebugType: Debug.Type { NetworkDataDebug.self }
    public var networkResponseDebugType: Debug.Type { NetworkResponseDebug.self }
    public var networkErrorDebugType: Debug.Type { NetworkErrorDebug.self }
    
    public func registerDebuggerConfiguration() {
        register(type: networkRequestDebugType)
        register(type: networkDataDebugType)
        register(type: networkResponseDebugType)
        register(type: networkErrorDebugType)
    }
}

public final class NetworkRequestDebug: Debug {}
public final class NetworkDataDebug: Debug {}
public final class NetworkResponseDebug: Debug {}
public final class NetworkErrorDebug: Debug {}
