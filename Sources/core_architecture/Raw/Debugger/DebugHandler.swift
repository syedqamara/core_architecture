//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import SwiftUI

public enum NetworkDebuggerActions: DebuggingAction, ModulingInput {
    case request(URLRequest), data(DataModel, DataModel.Type), error(Error), response(URLResponse)
}

public enum DebugModuleInputs {
    case debug(NetworkDebuggerActions)
}
