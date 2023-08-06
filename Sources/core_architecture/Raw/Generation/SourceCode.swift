//
//  Generation.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
// For Other file types.
public protocol Resourcable {
    var url: URL { get }
}
// For Codes
public protocol SourceCodable: Resourcable {}


extension Resourcable {
    var fileName: String? {
        url.lastPathComponent.components(separatedBy: .init(charactersIn: ".")).first
    }
    var fileExtension: String? {
        url.lastPathComponent.components(separatedBy: .init(charactersIn: ".")).last
    }
}
// sourcery: AutoMockable
public protocol SourceCodeGeneratable: IOProtocol where Input == SourceCodable, Output == String {
    
}
public protocol SourceCodeParsable: IOProtocol {
    init?(syntax: Input, url: URL)
    var url: URL { get }
    var syntax: Input { get set }
    func parse() -> Output?
}
