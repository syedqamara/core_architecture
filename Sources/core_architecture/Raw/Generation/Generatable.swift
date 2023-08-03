//
//  Localization.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
import Dependencies

// sourcery: AutoMockable
public protocol IOProtocol {
    associatedtype Input
    associatedtype Output
}
// sourcery: AutoMockable
public protocol Parsable: IOProtocol {
    func parse() -> Result<Output, Error>
}

