//
//  CoreDependencyValues.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Dependencies

extension DependencyValues {
    public var registerar: RegisteringSystem {
        get { self[RegisteringSystem.self] }
        set { self[RegisteringSystem.self] = newValue }
    }
}
