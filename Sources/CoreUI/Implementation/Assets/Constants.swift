//
//  Constants.swift
//  AppStoreManager
//
//  Created by Apple on 11/03/2024.
//


import SwiftUI

public enum ConstantType {
    case text(String)
    
    var description: String {
        switch self {
        case .text(let string):
            return string
        }
    }
}


public enum Constant {
    static let applicationInfo: ApplicationInfo = ApplicationInfo()
}

