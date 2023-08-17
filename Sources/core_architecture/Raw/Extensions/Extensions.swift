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
}

extension Dictionary where Key == String, Value == Any {
    public var headersDictionary: [String: String]? {
        self as? [String: String]
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
}
extension DataModel {
    public var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
