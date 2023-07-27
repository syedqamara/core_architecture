//
//  Localization.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
import Dependencies

// sourcery: AutoMockable
protocol Generatable {
    associatedtype Input
    associatedtype Output
    func generate(input: Input) -> Output
}

