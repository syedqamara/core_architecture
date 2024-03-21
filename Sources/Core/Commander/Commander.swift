//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation

public class Commander: CommandExecuting {
    private var queue = DispatchQueue(label: "com.core_architecture.command.executor.queue", qos: .userInitiated)
    public init() {}
    public func executeSerially<CI: CommandInput>(_ input: CI, completion: @escaping (Result<CI.Output, Error>) -> ()) {
        queue
            .sync {
                @Configuration("\(CI.Type.self)") var commandConfig: Commandable?
                if let commandConfig {
                    commandConfig.execute(input) { result in
                        switch result {
                        case .success(let success):
                            if let output = success as? CI.Output {
                                completion(.success(output))
                                return
                            }
                            completion(.failure(Errors.invalidOutput))
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                    }
                }
                completion(.failure(Errors.noCommandConfigFound))
                return
            }
    }
    public func execute<CI>(_ input: CI) async throws -> CI.Output where CI : CommandInput {
        @Configuration("\(CI.Type.self)") var commandConfig: Commandable?
        if let commandConfig {
            if let output = try await commandConfig.execute(input) as? CI.Output {
                return output
            }
            throw Errors.invalidOutput
        }
        throw Errors.noCommandConfigFound
    }
    
    enum Errors: String, Error {
        case invalidOutput, noCommandConfigFound
    }
}
