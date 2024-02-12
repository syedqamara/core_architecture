//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

public enum Failures: ErrorProvider {
    case local(LocalFileErrorCode), network(NetworkErrorCode)
    
    public var error: Erroring {
        switch self {
        case .local(let localFileErrorCode):
            return localFileErrorCode
        case .network(let networkErrorCode):
            return networkErrorCode
        }
    }
}
