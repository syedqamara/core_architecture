//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

enum Failures: ErrorProvider {
    case local(LocalFileErrorCode), network(NetworkErrorCode)
    
    var error: Erroring {
        switch self {
        case .local(let localFileErrorCode):
            return localFileErrorCode
        case .network(let networkErrorCode):
            return networkErrorCode
        }
    }
}
