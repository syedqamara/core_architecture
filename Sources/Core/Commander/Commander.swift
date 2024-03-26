//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation

public extension Configuration {
    init(_ commanderConfigKey: Commander.ConfigKeys) {
        self.init(commanderConfigKey.rawValue)
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
    public enum ConfigKeys {
        case configType(any CommandInput.Type)
        case executingCommandRef(String)
        
        public var rawValue: String {
            switch self {
            case .configType(let commandInput):
                return "command_config_type_\(commandInput.self)"
            case .executingCommandRef(let commandId):
                return "executing_command_id_\(commandId)"
            }
        }
    }
    
    private let queue: DispatchQueue
    private var logger: Log
    public init(id: String) {
        logger = Log(id: id)
        queue = DispatchQueue(label: "com.core_architecture.command.executor.\(id).queue", qos: .userInitiated)
    }
    private func infoLogType<CI: CommandInput>(_ type: CI.Type) -> Log.LogType { .info(configID: "\(CI.Type.self)") }
    private func warningLogType<CI: CommandInput>(_ type: CI.Type) -> Log.LogType{ .warning(configID: "\(CI.Type.self)") }
    private func errorLogType<CI: CommandInput>(_ type: CI.Type) -> Log.LogType { .error(configID: "\(CI.Type.self)") }
    
    public func executeSerially<CI: CommandInput>(_ input: CI, completion: @escaping (Result<CI.Output, Error> ) -> ()) {
        queue
            .sync {
                @Configuration(ConfigKeys.configType(CI.self)) var commandConfigType: Commandable.Type?
                if let commandConfigType {
                    let taskid = UUID().uuidString
                    let commandConfig = commandConfigType.init(executor: Commander(id: taskid))
                    @Configuration(ConfigKeys.executingCommandRef(taskid)) var command: Commandable?
                    command = commandConfig
                    logger.trackLog(
                        type: infoLogType(CI.self),
                        input,
                        action: .foundCommandConfig
                    )
                    commandConfig.execute(input) {
                        [logger, weak self]
                        result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let success):
                            if let output = success as? CI.Output {
                                completion(.success(output))
                                logger.trackLog(
                                    type: infoLogType(CI.self),
                                    input,
                                    action: .foundCommandConfig
                                )
                                return
                            }
                            completion(.failure(Errors.invalidOutput))
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                        @Configuration(ConfigKeys.executingCommandRef(taskid)) var executingCommandRef: Commandable?
                        executingCommandRef = nil
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
