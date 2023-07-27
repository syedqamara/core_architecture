//
//  Generation.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation


protocol SourceCode {
    var url: URL { get }
}

extension SourceCode {
//    var fileName: String? {
//        url.lastPathComponent.components(separatedBy: .init(".")).first
//    }
//    var fileExtension: String? {
//        url.lastPathComponent.components(separatedBy: .init(".")).last
//    }
}
// sourcery: AutoMockable
protocol SourceCodeGeneratable: Generatable where Input == SourceCode {
    
}
