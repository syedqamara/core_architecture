//
//  Localization.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
import Dependencies

// sourcery: AutoMockable
protocol IOProtocol {
    associatedtype Input
    associatedtype Output
}
// sourcery: AutoMockable
protocol Parsable: IOProtocol {
    func parse() -> Result<Output, Error>
}

