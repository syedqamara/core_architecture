//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
import OSLog
public protocol LogAction {
    var rawValue: String { get }
}
private let lineBarTextConstant = "\n\n--------------------------------------------\n\n"
public class Logs<L: LogAction>: Logging {
    public typealias LoggingAction = L
    
    public enum LogType {
        case warning(configID: String), info(configID: String), error(configID: String)
        
        public var configID: String {
            switch self {
            case .warning(let configID):
                return configID
            case .info(let configID):
                return configID
            case .error(let configID):
                return configID
            }
        }
        var type: String {
            switch self {
            case .warning(_):
                return "warning"
            case .info(_):
                return "info"
            case .error(_):
                return "error"
            }
        }
        var sign: String {
            switch self {
            case .warning(_):
                return "⚠️ "
            case .info(_):
                return "‼️ "
            case .error(_):
                return "❌ "
            }
        }
    }
    private let id: String
    private var logs: [String: String] = [:]
    public init(id: String) {
        self.id = id
    }
    public func saveLogs(key: String, value: String) {
        self.logs[key] = value
    }
    public func printStructuredInfo(completion: @autoclosure () -> String?, action: L) -> String {
        return """
        Log ID  :  \(id)
        Action  :  \(action)
        Log Info:  \(completion() ?? "")
        """
    }
    // Log must be perform in order to push all the requested log flow for specific configID.
    public func log(log: LogType) {
        guard let value = logs[log.configID] else { return }
        switch log {
        case .warning(_):
            print("\(value)")
        case .info(_):
            print("\(value)")
        case .error(_):
            print("\(value)")
        }
    }
    public func trackLog<D>(type: LogType, data: D?, action: L) {
        
    }
    private func storeLogs(content: String, type: LogType) {
        let beautifyContent = type.sign + content + type.sign
        if let value = logs[type.configID] {
            let finalLog = value + lineBarTextConstant + beautifyContent
            logs[type.configID] = finalLog
        } else {
            logs[type.configID] = beautifyContent
        }
    }
}

extension Logs {
    public func trackLog(type: LogType, data: Data?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: data?.string ?? "", action: action)
    }
    
    public func trackLog(type: LogType, data: [String: Any]?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: (data ?? [:]).description, action: action)
    }
    
    public func trackLog(type: LogType, data: Any?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: data), action: action)
    }
    public func trackLog(type: LogType, data: URLRequest?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: data), action: action)
    }
    public func trackLog(type: LogType, data: URL?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: data), action: action)
    }
    public func trackLog(type: LogType, data: Error?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: data), action: action)
    }
}
