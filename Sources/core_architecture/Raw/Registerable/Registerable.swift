//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation

public protocol Registering {
    var id: String { get }
    var isEmpty: Bool { get }
}
extension Registering {
    public var isEmpty: Bool {
        @Configuration<Any>(id) var config
        return config == nil
    }
}
// Registering system manager
public class RegisteringSystem {
    public init(){}
}
