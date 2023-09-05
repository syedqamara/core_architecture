//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

public extension String {
    var isNotEmpty: Bool { !isEmpty }
}
public extension Array {
    var isNotEmpty: Bool { !isEmpty }
}
public extension Dictionary {
    var isNotEmpty: Bool { !isEmpty }
}
extension Data {
    public func printJSON() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
    public var string: String? {
        String(data: self, encoding: .utf8)
    }
    public func dictionary() -> [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any] {
            return json
        }
        return nil
    }
    func prettyPrintJSON() {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                print(prettyPrintedString)
            }
        } catch {
            print("Error pretty-printing JSON: \(error)")
        }
    }
    
    public func prettyJSONString() throws -> String {
        let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
        let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        
        if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
            return prettyPrintedString
        }
        return ""
    }
}
public enum JSONValue {
    case stringValue(String)
    case intValue(Int)
    case doubleValue(Double)
    case boolValue(Bool)
    case arrayValue([KeyValueData])
    case keyValue([KeyValueData])
}
public struct KeyValueData {
    public var key: String
    public var value: JSONValue
    
    public var dictionary: [String: Any] {
        return value.dictionary(key: key)
    }
}
extension JSONValue: CustomStringConvertible {
    public var description: String {
        switch self {
            case .stringValue(let value):
                return value
            case .arrayValue(let array):
            let elements = array.map { $0.value.description }.joined(separator: ", ")
                return "[\(elements)]"
            case .keyValue(let dictionary):
                let elements = dictionary.map { "\"\($0.key)\": \($0.value.description)" }.joined(separator: ", ")
                return "{\(elements)}"
        case .intValue(let value):
            return String(describing: value)
        case .doubleValue(let value):
            return String(describing: value)
        case .boolValue(let value):
            return String(describing: value)
        }
    }
    func dictionary(key: String) -> [String: Any] {
        switch self {
            case .stringValue(let value):
                return [key: value]
            case .intValue(let value):
                return [key: value]
            case .doubleValue(let value):
                return [key: value]
            case .boolValue(let value):
                return [key: value]
            case .arrayValue(let array):
            return [key: self.array(array: array)]
            case .keyValue(let dictionary):
                return [key: dictionary.map { $0.dictionary }.merge()]
        }
    }
    func array(array: [KeyValueData]) -> [Any] {
        return array.reduce([Any]()) { partialResult, kv in
            var resultArray = partialResult
            switch kv.value {
                case .stringValue(let value):
                    resultArray.append(value)
                    break
                case .intValue(let value):
                    resultArray.append(value)
                    break
                case .doubleValue(let value):
                    resultArray.append(value)
                    break
                case .boolValue(let value):
                    resultArray.append(value)
                    break
                case .arrayValue(let array):
                    resultArray.append(self.array(array: array))
                    break
                case .keyValue(let dictionary):
                    resultArray.append(dictionary.map { $0.dictionary }.merge())
                    break
            }
            return resultArray
        }
    }
}
extension Dictionary where Key == String, Value == Any {
    public var headersDictionary: [String: String]? {
        self as? [String: String]
    }
    public func keyValues() -> [KeyValueData] {
        return parseJSONData()
    }
    // Parse JSON and return an array of [KeyValueData]
    func parseJSONData() -> [KeyValueData] {
        var keyValueArray: [KeyValueData] = []

        for (key, value) in self {
            if let jsonValue = parseValue(value) {
                let keyValue = KeyValueData(key: key, value: jsonValue)
                keyValueArray.append(keyValue)
            }
        }
        
        return keyValueArray
    }

    // Helper function to parse JSON values
    func parseValue(_ value: Any) -> JSONValue? {
        if let arrayValue = value as? [Any] {
            var keyValueArray: [KeyValueData] = []
            
            for (index, element) in arrayValue.enumerated() {
                if let jsonValue = parseValue(element) {
                    let key = "[\(index)]"
                    let keyValue = KeyValueData(key: key, value: jsonValue)
                    keyValueArray.append(keyValue)
                }
            }
            
            return .arrayValue(keyValueArray.debugDataSorting)
        } else if let dictionaryValue = value as? [String: Any] {
            var keyValueArray: [KeyValueData] = []
            
            for (key, element) in dictionaryValue {
                if let jsonValue = parseValue(element) {
                    let keyValue = KeyValueData(key: key, value: jsonValue)
                    keyValueArray.append(keyValue)
                }
            }
            
            return .keyValue(keyValueArray.debugDataSorting)
        } else if let convertedValue = value as? String {
            return .stringValue(convertedValue)
        } else if let convertedValue = value as? Int {
            return .intValue(convertedValue)
        } else if let convertedValue = value as? Double {
            return .doubleValue(convertedValue)
        } else if let convertedValue = value as? Bool {
            return .boolValue(convertedValue)
        }else {
            return .stringValue(String(describing: value))
        }
        
        return nil
    }
    public func decode<C: Codable>(_ type: C.Type) -> C? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return try JSONDecoder().decode(type, from: jsonData)
        } catch {
            print("Error converting dictionary to Data: \(error)")
            return nil
        }
    }
    public func data() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return jsonData
        } catch {
            print("Error converting dictionary to Data: \(error)")
            return nil
        }
    }
}
extension Array where Element == KeyValueData {
    public var debugDataSorting: Self {
        var strings: [KeyValueData] = []
        var ints: [KeyValueData] = []
        var doubles: [KeyValueData] = []
        var bools: [KeyValueData] = []
        var arrays: [KeyValueData] = []
        var dicts: [KeyValueData] = []
        for kv in self {
            switch kv.value {
            case .stringValue(_):
                strings.append(kv)
                break
            case .arrayValue(_):
                arrays.append(kv)
                break
            case .keyValue(_):
                dicts.append(kv)
                break
            case .intValue(_):
                ints.append(kv)
            case .doubleValue(_):
                doubles.append(kv)
            case .boolValue(_):
                bools.append(kv)
            }
        }
        return doubles + ints + bools + strings + dicts + arrays
    }
}
extension Array where Element == [String: Any] {
    public func merge() -> [String: Any] {
        var mergedDictionary: [String: Any] = [:]
        
        for dictionary in self {
            for (key, value) in dictionary {
                mergedDictionary[key] = value
            }
        }
        
        return mergedDictionary
    }
}
extension Dictionary where Key == String, Value == String {
    public var toURLString: String {
        var keyValuesArray: [String] = []
        for (k,v) in self {
            let temporary = k + "=" + v
            if let tmp = temporary.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                keyValuesArray.append(tmp)
            }
        }
        return keyValuesArray.joined(separator: "&")
    }
    public func prettyPrintJSONString() -> String {
        do {
            let prettyPrintedData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                return prettyPrintedString
            }
        } catch {
            
        }
        return "{}"
    }
}
extension DataModel {
    public var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension URL {
    public mutating func insert(params: String) {
        var finalString = self.absoluteString
        if finalString.contains("?") {
            if let last = finalString.last {
                let lastString = String(last)
                if lastString == "&" || lastString == "?" {
                    finalString += params
                } else {
                    finalString += "&\(params)"
                }
            } else {
                finalString += "&\(params)"
            }
        }else {
            finalString += "?\(params)"
        }
    }
}
