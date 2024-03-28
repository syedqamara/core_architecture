//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation

public protocol CommandInput {
    associatedtype Output: CommandOutput
}
public protocol CommandOutput {
    
}

public protocol Commandable: AnyObject {
    init(executor: (any CommandExecuting)?)
    func execute(_ input: any CommandInput) async throws -> CommandOutput
    func execute(_ input: any CommandInput, completion: @escaping (Result<CommandOutput, Error>) -> ())
}


public protocol CommandExecuting: AnyObject {
    associatedtype Log: Logging
    func execute<CI: CommandInput>(_ input: CI) async throws -> CI.Output
}

public extension CommandExecuting {
    static func register<C: Commandable, CI: CommandInput>(id: CI.Type, command: C.Type) {
        @Configuration(commanderConfigKey: Commander.ConfigKeys.configType(String(describing: CI.self))) var commandConfig: C.Type?
        _commandConfig.wrappedValue = command
    }
}
