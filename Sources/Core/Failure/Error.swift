//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

public protocol Erroring: Error {
    var code: Int { get }
    var identifier: String { get }
    var message: String { get }
}

public protocol ErrorProvider {
    var error: Erroring { get }
}



