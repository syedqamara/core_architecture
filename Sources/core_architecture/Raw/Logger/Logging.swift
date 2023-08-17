//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

public protocol LogAction {
    var rawValue: String { get }
}

public class Logs<L: LogAction> {
    private let id: String
    public init(id: String) {
        self.id = id
    }
    private func printStructuredInfo(completion: @autoclosure () -> String?, action: L) -> String {
        return """
        Log ID  :  \(id)
        Action  :  \(action)
        Log Info:  \(completion() ?? "")
        """
    }
    
    public func log(_ data: Data?, action: L) {
        print(printStructuredInfo(completion: data?.string ?? "", action: action))
    }
    
    public func log(_ dictionary: [String: Any]?, action: L) {
        print(printStructuredInfo(completion: dictionary?.description, action: action))
    }
    
    public func log(_ any: Any?, action: L) {
        print(printStructuredInfo(completion: String(describing: any), action: action))
    }
}
