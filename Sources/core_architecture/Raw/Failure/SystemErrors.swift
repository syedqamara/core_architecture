//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation

public enum SystemError {
case custom(Error), network(NetworkErrorCode), debugger(DebuggerErrorCode), registration(RegistrationErrorCode)
}

extension SystemError: Erroring {
    
    public var code: Int {
        switch self {
        case .custom(let error):
            if let networkErrorCode = error as? NetworkErrorCode {
                return networkErrorCode.rawValue
            }
            else if let networkError = error as? SystemError {
                return networkError.code
            }
            else {
                return (error as NSError).code
            }
        case .network(let error):
            return error.code
        case .debugger(let error):
            return error.code
        case .registration(let error):
            return error.code
        }
    }
    
    public var identifier: String {
        switch self {
        case .custom(let error):
            return (error as NSError).domain
        case .network(let error):
            return error.identifier
        case .debugger(let error):
            return error.identifier
        case .registration(let error):
            return error.identifier
        }
    }
    
    public var message: String {
        switch self {
        case .custom(let error):
            return (error as NSError).description
        case .network(let error):
            return error.message
        case .debugger(let error):
            return error.message
        case .registration(let error):
            return error.message
        }
    }
}
extension SystemError {
    public func isEqual(to: SystemError) -> Bool {
        print("***** Error Comparing *****")
        print("Network Returning Error    \(self)")
        print("Expected Returning Error   \(to)")
        print("***** Error Comparing Ended *****")
        return code == to.code
    }
}
