//
//  File.swift
//  
//
//  Created by Apple on 28/01/2024.
//

import Foundation
import Core

@propertyWrapper
public struct Skin<Value: Skinning> {
    private let key: String
    public init(_ key: String) {
        self.key = key
    }
    public var wrappedValue: Value {
        get {
            @Configuration<Value>(key) var theme: Value?
            return theme ?? .default
        }
        set {
            @Configuration<Value>(key) var theme: Value?
            theme = newValue
        }
    }
}
