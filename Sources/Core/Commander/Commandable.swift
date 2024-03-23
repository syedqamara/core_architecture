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
    init(executor: CommandExecuting?)
    func execute(_ input: any CommandInput) async throws -> CommandOutput
    func execute(_ input: any CommandInput, completion: @escaping (Result<CommandOutput, Error>) -> ())
}


public protocol CommandExecuting {
    func execute<CI: CommandInput>(_ input: CI) async throws -> CI.Output
}

public extension CommandExecuting {
    func register<C: Commandable, CI: CommandInput>(id: CI.Type, command: C.Type) {
        @Configuration("\(id)") var commandConfig: C?
        commandConfig = command.init(executor: self)
    }
}
