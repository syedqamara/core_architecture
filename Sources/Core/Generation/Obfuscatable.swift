//
//  File.swift
//  
//
//  Created by Apple on 27/07/2023.
//

import Foundation


public struct ObfuscationKey {
    var key: String
    var name: String
}

extension ObfuscationKey {
    static func property(_ name: String) -> Self { .init(key: "property_", name: name) }
    static func type(_ name: String) -> Self { .init(key: "type_", name: name) }
    static func function(_ name: String) -> Self { .init(key: "function_", name: name) }
    static func `struct`(_ name: String) -> Self { .init(key: "struct_", name: name) }
    static func `class`(_ name: String) -> Self { .init(key: "class_", name: name) }
    static func `protocol`(_ name: String) -> Self { .init(key: "protocol_", name: name) }
}

public class Obfuscation: Obfuscatable {
    public static let shared = Obfuscation()
    private var counter: Int = 1
    private var cache: [String: String] = [:]
    private var noneObfuscationKeys: [String: Bool] = [:]
    private let counterQueue = DispatchQueue(label: "com.example.obfuscation.counterQueue", attributes: .concurrent)
    private init() {
        
    }
    func excludeKeys(_ keys: [String]) {
        keys.forEach { noneObfuscationKeys[$0] = true }
    }
    func findMatchingKey(for searchText: String) -> String? {
        // First, check for an exact match in the dictionary
        if let exactMatch = noneObfuscationKeys[searchText], exactMatch {
            return searchText
        }

        // If no exact match is found, search for partial matches
        let partialMatches = noneObfuscationKeys.keys.filter { key in
            key.range(of: searchText, options: .caseInsensitive) != nil
        }

        return partialMatches.first
    }
    public func ofuscate(input: ObfuscationKey) -> String {
        if let noneObfuscationValue = findMatchingKey(for: input.name), noneObfuscationValue.isNotEmpty {
            return noneObfuscationValue
        }
        if let cacheValue = cache[input.name] {
            return cacheValue
        }
        var result: String = ""

        // Synchronously increment the counter using a concurrent queue
        counterQueue.sync(flags: .barrier) {
            // Append prefix.key and the current counter value to form the result
            result = input.key + "\(counter)"
            // Increment the counter
            counter += 1
            cache[input.name] = result
        }

        return result
    }
}

extension Obfuscation {
    class var defaultDataTypes: [String] {
        [
            "Int",
            "Bool",
            "Float",
            "CGFloat",
            "String",
            "Double",
            "Array<Int>",
            "Array<Bool>",
            "Array<Float>",
            "Array<CGFloat>",
            "Array<String>",
            "Array<Double>",
            "Dictionary<Int, Int>",
            "Dictionary<Bool, Bool>",
            "Dictionary<Float, Float>",
            "Dictionary<CGFloat, CGFloat>",
            "Dictionary<String, String>",
            "Dictionary<Double, Double>",
            "Dictionary<String, Any>",
            // Add more types here
            "Set<Int>",
            "Set<Bool>",
            "Set<Float>",
            "Set<CGFloat>",
            "Set<String>",
            "Set<Double>",
            "Character",
            "UUID",
            "Optional<Int>",
            "Optional<Bool>",
            "Optional<Float>",
            "Optional<CGFloat>",
            "Optional<String>",
            "Optional<Double>",
            "Result<Int, Error>",
            "Result<Bool, Error>",
            "Result<Float, Error>",
            "Result<CGFloat, Error>",
            "Result<String, Error>",
            "Result<Double, Error>",
            "Tuple2<Int, Bool>",
            "Tuple3<Float, String, Double>",
            "Tuple4<CGFloat, Int, Bool, String>",
            "Tuple5<Double, CGFloat, Int, Bool, String>"
        ]
    }
}
// sourcery: AutoMockable
public protocol Obfuscatable: IOProtocol where Input == ObfuscationKey, Output == String {
    func ofuscate(input: ObfuscationKey) -> String
}

@propertyWrapper
public struct Obfuscate {
    private let key: ObfuscationKey
    public var wrappedValue: String {
        Obfuscation.shared.ofuscate(input: key)
    }
    init(_ key: ObfuscationKey) {
        self.key = key
    }
}

