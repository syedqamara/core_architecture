//
//  DebugConfigurationUI.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import SwiftUI
import Debugger
import core_architecture
import Dependencies


public struct DebugUITheme {
    
}

extension DebugUITheme {
    public struct NetworkDebugModule {
        public struct KeyValue: Configurable {
            public let configID: String = UUID().uuidString
            // Color
            public let borderColor: Color
            public let backgroundColor: Color
            public let keyTiteColor: Color
            public let valueTiteColor: Color
            
            // Fonts
            public let navigationTitleFont: Font
            public let headerTitleFont: Font
            public let keyTitleFont: Font
            public let valueTitleFont: Font
            // Padding
            public let headerPadding: CGFloat
            public let keyPadding: CGFloat
            public let valuePadding: CGFloat
            // Sizes
            public let headerHeight: CGFloat
            public let jsonContentHeight: CGFloat
            
            // Border Radius
            public let radius: CGFloat
            public init(borderColor: Color, backgroundColor: Color, keyTiteColor: Color, valueTiteColor: Color, navigationTitleFont: Font, headerTitleFont: Font, keyTitleFont: Font, valueTitleFont: Font, headerPadding: CGFloat, keyPadding: CGFloat, valuePadding: CGFloat, headerHeight: CGFloat, jsonContentHeight: CGFloat, radius: CGFloat) {
                self.navigationTitleFont = navigationTitleFont
                self.borderColor = borderColor
                self.backgroundColor = backgroundColor
                self.keyTiteColor = keyTiteColor
                self.valueTiteColor = valueTiteColor
                self.headerTitleFont = headerTitleFont
                self.keyTitleFont = keyTitleFont
                self.valueTitleFont = valueTitleFont
                self.headerPadding = headerPadding
                self.keyPadding = keyPadding
                self.valuePadding = valuePadding
                self.headerHeight = headerHeight
                self.jsonContentHeight = jsonContentHeight
                self.radius = radius
            }
        }
    }
}

extension DebugUITheme.NetworkDebugModule.KeyValue: DependencyKey {
    public static var liveValue: DebugUITheme.NetworkDebugModule.KeyValue {
        .init(
            borderColor: .red,
            backgroundColor: .black,
            keyTiteColor: .white,
            valueTiteColor: .red,
            
            navigationTitleFont: .title2.bold(),
            headerTitleFont: .subheadline.bold(),
            keyTitleFont: .caption.bold(),
            valueTitleFont: .caption.bold(),
            
            headerPadding: 5,
            keyPadding: 5,
            valuePadding: 5,
            
            headerHeight: 30,
            jsonContentHeight: 20,
            
            radius: 10
        )
    }
}

public extension DependencyValues {
    var networkModuleKeyValueTheme: DebugUITheme.NetworkDebugModule.KeyValue {
        get {
            let dependencyValue = self[DebugUITheme.NetworkDebugModule.KeyValue.self]
            @Configuration<DebugUITheme.NetworkDebugModule.KeyValue>(dependencyValue.configID) var theme
            if let theme {
                return theme
            }
            return dependencyValue
        }
        set {
            @Configuration<DebugUITheme.NetworkDebugModule.KeyValue>(newValue.configID) var theme: DebugUITheme.NetworkDebugModule.KeyValue?
            _theme.wrappedValue = newValue
            self[DebugUITheme.NetworkDebugModule.KeyValue.self] = newValue
        }
    }
}
