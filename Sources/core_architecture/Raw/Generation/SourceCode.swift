//
//  Generation.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

protocol SourceCodable {
    var url: URL { get }
}


extension SourceCodable {
    var fileName: String? {
        url.lastPathComponent.components(separatedBy: .init(charactersIn: ".")).first
    }
    var fileExtension: String? {
        url.lastPathComponent.components(separatedBy: .init(charactersIn: ".")).last
    }
}
// sourcery: AutoMockable
protocol SourceCodeGeneratable: IOProtocol where Input == SourceCodable, Output == String {
    
}
protocol SourceCodeParsable: IOProtocol {
    init?(syntax: Input, url: URL)
    var url: URL { get }
    var syntax: Input { get set }
    func parse() -> Output?
}
