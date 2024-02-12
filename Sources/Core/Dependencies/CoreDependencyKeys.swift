//
//  CoreDependencyKeys.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Dependencies

extension RegisteringSystem: TestDependencyKey, DependencyKey {
    public static var liveValue: RegisteringSystem { .init() }
    public static var testValue: RegisteringSystem { .init() }
}

