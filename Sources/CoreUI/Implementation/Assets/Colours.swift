//
//  Colours.swift
//  AppStoreManager
//
//  Created by Apple on 11/03/2024.
//


import UIKit


public typealias Colours = ColorInputType

public enum ColorInputType {
    case rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat), asset(String), hex(String)
    
    /// If any color is nil the default value in that case will be `.black` color
    public var color: UIColor {
        switch self {
        case .rgb(let red, let green, let blue, let alpha):
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        case .asset(let string):
            return UIColor(named: string) ?? .black
        case .hex(let hex):
            return UIColor(hex: hex) ?? .black
        }
    }
}

extension Colours {
    static public let appThemePrimaryBackgroundColor: ColorInputType = .asset("app_theme_primary_bg")
    static public let appThemeSecondaryBackgroundColor: ColorInputType = .asset("app_theme_secondary_bg")
    
    static public let appThemePrimaryTextColor: ColorInputType = .asset("app_theme_primary_bg")
    static public let appThemeSecondaryTextColor: ColorInputType = .asset("app_theme_secondary_bg")
    
    static public let appThemePrimaryBorderColor: ColorInputType = .asset("app_theme_primary_bg")
    static public let appThemeSecondaryBorderColor: ColorInputType = .asset("app_theme_secondary_bg")
    
}

