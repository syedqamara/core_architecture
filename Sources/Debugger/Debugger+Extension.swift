//
//  File.swift
//  
//
//  Created by Apple on 06/12/2023.
//

import Foundation
import core_architecture

public extension Debugger {
    func debugError(config: Debugable, error: Error, continuation: Continuation<DataModel, Error>) {
        do {
            let debugResult = try self.debug(debug: config, feature: NetworkErrorDebug.self)
            switch debugResult {
            case .console:
                if let action = self.action(actionType: NetworkDebuggerActions.self)?.action {
                    action(.init(configID: config.configID, debugID: config.debugID,debugData: .error(error))) { actionBack in
                        if case .error(let freshError) = actionBack.debugData {
                            continuation.resume(throwing: SystemError.custom(freshError))
                        }
                    }
                }else {
                    continuation.resume(throwing: SystemError.custom(error))
                    break
                }
            case .ignore:
                continuation.resume(throwing: SystemError.custom(error))
                break
            }
        }
        catch let error {
            continuation.resume(throwing: error)
        }
    }
    func debugData(config: Debugable, type: DataModel.Type, data: DataModel, continuation: Continuation<DataModel, Error>) {
        do {
            let debugResult = try self.debug(debug: config, feature: NetworkDataDebug.self)
            switch debugResult {
            case .console:
                if let action = self.action(actionType: NetworkDebuggerActions.self)?.action {
                    action(.init(configID: config.configID, debugID: config.debugID, debugData: .data(data, type))) { actionback in
                        if case .data(let dataModel, _) = actionback.debugData {
                            continuation.resume(returning: dataModel)
                        }else {
                            continuation.resume(returning: data)
                        }
                    }
                }else {
                    continuation.resume(returning: data)
                    break
                }
            case .ignore:
                continuation.resume(returning: data)
                break
            }
        }
        catch let error {
            continuation.resume(throwing: error)
        }
    }
    func debugRequest(config: Debugable, request: URLRequest, continuation: Continuation<URLRequest, Error>) {
        do {
            let requestDebuggingResult = try debug(debug: config, feature: NetworkRequestDebug.self)
            switch requestDebuggingResult {
            case .console:
                if let action = action(actionType: NetworkDebuggerActions.self) {
                    action.action(.init(configID: config.configID, debugID: config.debugID, debugData: .request(request))) {
                        returnedAction in
                        switch returnedAction.debugData {
                        case .request(let newRequest):
                            continuation.resume(returning: newRequest)
                            break
                        default:
                            break

                        }
                    }
                }
            case .ignore:
                continuation.resume(returning: request)
            }
        }
        catch let err {
            continuation.resume(throwing: err)
        }
    }
}
