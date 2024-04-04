//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
import Dependencies

public extension Configuration {
    init(commanderConfigKey: ConfigKeys) {
        self.init(commanderConfigKey.rawValue)
    }
}
public enum ConfigKeys: Hashable {
    public static func == (lhs: ConfigKeys, rhs: ConfigKeys) -> Bool {
        switch lhs {
        case .configType(_):
            if case .configType(_) = rhs {
                return true
            }
        case .executingCommandRef(_):
            if case .executingCommandRef(_) = rhs {
                return true
            }
        }
        return false
    }
    
    case configType(String)
    case executingCommandRef(String)
    
    public var rawValue: String {
        switch self {
        case .configType(let commandInput):
            return "command_config_type_\(commandInput)"
        case .executingCommandRef(let commandId):
            return "executing_command_id_\(commandId)"
        }
    }
    public func hash(into hasher: inout Hasher) {
        // Hash based on the rawValue of each case
        switch self {
        case .configType(let commandInput):
            hasher.combine("configType")
            hasher.combine(commandInput)
        case .executingCommandRef(let commandId):
            hasher.combine("executingCommandRef")
            hasher.combine(commandId)
        }
    }
}
public class Commander: CommandExecuting {
    public typealias Log = Logs<LogActions>
    
    public enum LogActions: String, LogAction {
    case recievedErrorFromCommand
    case recievedSuccessFromCommand
    case recievedInvalidResultFromCommand
    case foundCommandConfig
    case noCommandConfigFound
    }
    
    
    private let serialQueue: DispatchQueue
    private let concurrentQueue: DispatchQueue
    private var logger: Log
    
    private var executionDictionary: [ConfigKeys: Commandable] = [:]
    private let executionDictionaryQueue = DispatchQueue(label: "com.example.app.executionDictionaryQueue", attributes: .concurrent)

    // Method to access executionDictionary safely
    private func setExecutionDictionary<T>(block: () -> T) -> T {
        return executionDictionaryQueue.sync(flags: .barrier) {
            return block()
        }
    }
    // Method to access executionDictionary safely
    private func accessExecutionDictionary<T>(block: () -> T) -> T {
        return executionDictionaryQueue.sync {
            return block()
        }
    }

    // Usage example
    func addToExecutionDictionary(key: ConfigKeys, value: Commandable?) {
        setExecutionDictionary {
            executionDictionary[key] = value
        }
    }

    
    public init(id: String) {
        logger = Log(id: id)
        serialQueue = DispatchQueue(label: "com.core_architecture.command.executor.\(id).queue", qos: .userInitiated)
        concurrentQueue = DispatchQueue(label: "com.core_architecture.command.executor.\(id).queue", qos: .background, attributes: .concurrent)
    }
    private func infoLogType<CI: CommandInput>(_ type: CI.Type) -> Log.LogType { .info(configID: "\(CI.Type.self)") }
    private func warningLogType<CI: CommandInput>(_ type: CI.Type) -> Log.LogType{ .warning(configID: "\(CI.Type.self)") }
    private func errorLogType<CI: CommandInput>(_ type: CI.Type) -> Log.LogType { .error(configID: "\(CI.Type.self)") }
    
    public func executeSerially<CI: CommandInput>(_ input: CI, completion: @escaping (Result<CI.Output, Error> ) -> ()) {
        @Configuration(commanderConfigKey: ConfigKeys.configType(String(describing: CI.self))) var commandConfigType: Commandable.Type?
        serialQueue
            .sync {
                if let commandConfigType {
                    @Dependency(\.uuid) var uuidGenerator
                    let taskid = uuidGenerator.callAsFunction().uuidString
                    let commandConfig = commandConfigType.init(executor: Commander(id: taskid))
                    self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: commandConfig)
                    logger.trackLog(
                        type: infoLogType(CI.self),
                        data: input,
                        action: .foundCommandConfig
                    )
                    commandConfig.execute(input) {
                        [logger, weak self]
                        result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let success):
                            if let output = success as? CI.Output {
                                logger.trackLog(
                                    type: infoLogType(CI.self),
                                    data: input,
                                    action: .foundCommandConfig
                                )
                                self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: nil)
                                completion(.success(output))
                                return
                            } else {
                                self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: nil)
                                completion(.failure(Errors.invalidOutput))
                            }
                            
                        case .failure(let failure):
                            self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: nil)
                            completion(.failure(failure))
                        }
                    }
                    return
                }
                completion(.failure(Errors.noCommandConfigFound))
                return
            }
    }
    public func executeAschronously<CI: CommandInput>(_ input: CI, completion: @escaping (Result<CI.Output, Error> ) -> ()) {
        @Configuration(commanderConfigKey: ConfigKeys.configType(String(describing: CI.self))) var commandConfigType: Commandable.Type?
        concurrentQueue
            .async {
                [weak self] in
                guard let self = self else { return }
                if let commandConfigType {
                    let taskid = UUID().uuidString
                    let commandConfig = commandConfigType.init(executor: Commander(id: taskid))
                    self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: commandConfig)
                    self.logger.trackLog(
                        type: self.infoLogType(CI.self),
                        data: input,
                        action: .foundCommandConfig
                    )
                    commandConfig.execute(input) {
                        [weak self]
                        result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let success):
                            if let output = success as? CI.Output {
                                self.logger.trackLog(
                                    type: infoLogType(CI.self),
                                    data: input,
                                    action: .foundCommandConfig
                                )
                                self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: nil)
                                completion(.success(output))
                                return
                            } else {
                                self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: nil)
                                completion(.failure(Errors.invalidOutput))
                            }
                            
                        case .failure(let failure):
                            self.addToExecutionDictionary(key: .executingCommandRef(taskid), value: nil)
                            completion(.failure(failure))
                        }
                    }
                    return
                }
                completion(.failure(Errors.noCommandConfigFound))
                return
            }
    }
    public func execute<CI>(_ input: CI) async throws -> CI.Output where CI : CommandInput {
        try await withCheckedThrowingContinuation { cont in
            self.executeSerially(input) { result in
                cont.resume(with: result)
            }
        }
    }
    
    enum Errors: String, Error {
        case invalidOutput, noCommandConfigFound
    }
}
