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
public class Logs<L: LogAction> {
    public enum LogType {
        case warning(configID: String), info(configID: String), error(configID: String)
        
        var configID: String {
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
    private func printStructuredInfo(completion: @autoclosure () -> String?, action: L) -> String {
        return """
        Log ID  :  \(id)
        Action  :  \(action)
        Log Info:  \(completion() ?? "")
        """
    }
    // Log must be perform in order to push all the requested log flow for specific configID.
    public func log(log: LogType) {
        guard let value = logs[log.configID] else { return }
        let logger = Logger(subsystem: log.type, category: log.configID)
        switch log {
        case .warning(_):
            print("\(value)")
        case .info(_):
            print("\(value)")
        case .error(_):
            print("\(value)")
        }
    }
    private func storeLogs(content: String, type: LogType) {
        let beautifyContent = type.sign + content + type.sign
        if let value = logs[type.configID] {
            let finalLog = value + lineBarTextConstant + content
            logs[type.configID] = finalLog
        } else {
            logs[type.configID] = content
        }
    }
}

extension Logs {
    public func trackLog(type: LogType,_ data: Data?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: data?.string ?? "", action: action)
    }
    
    public func trackLog(type: LogType,_ dictionary: [String: Any]?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: (dictionary ?? [:]).description, action: action)
    }
    
    public func trackLog(type: LogType,_ any: Any?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: any), action: action)
    }
    public func trackLog(type: LogType,_ any: URLRequest?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: any), action: action)
    }
    public func trackLog(type: LogType,_ any: URL?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: any), action: action)
    }
    public func trackLog(type: LogType,_ any: Error?, action: L) {
        logs[type.configID] = printStructuredInfo(completion: String(describing: any), action: action)
    }
}
