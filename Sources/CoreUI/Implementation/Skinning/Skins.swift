//
//  File.swift
//  
//
//  Created by Apple on 28/01/2024.
//

import Foundation
import SwiftUI
import Core
import Dependencies

// SizableSkinning Implementation
public struct SizableSkin: SizableSkinning {
    public static var `default`: Self { .init() }
    
    public var borderWidth: CGFloat = 0
    public var cornerRadius: CGFloat = 0
    public var configID: String = ""
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var padding: UIEdgeInsets = .init()
    // SizableSkinning protocol implementation
}


// ColourfulSkinning Implementation
public struct ColourfulSkin: ColourfulSkinning {
    public static var `default`: ColourfulSkin { .init() }
    public var backgroundColor: UIColor = .clear
    public var foreGroundColor: UIColor = .clear
    public var tintColor: UIColor = .clear
    public var borderColor: UIColor = .clear
    // ColourfulSkinning protocol implementation
}

// ViewSkinning Implementation
public struct ViewSkin: ViewSkinning {
    public var configID: String
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // ViewSkinning protocol implementation
    public init(configID: String, color: ColourfulSkinning? = nil, size: SizableSkinning? = nil) {
        self.configID = configID
        self.color = color
        self.size = size
    }
    public static var `default`: ViewSkin {
        ViewSkin(
            configID: "application_core_ui_views_default_view_skin",
            color: ColourfulSkin(
                backgroundColor: .orange,
                foreGroundColor: .black,
                borderColor: .red
            ),
            size: SizableSkin(
                borderWidth: 2,
                cornerRadius: 5,
                width: 100,
                height: 100,
                padding: .init(
                    top: 5,
                    left: 5,
                    bottom: 5,
                    right: 5
                )
            )
        )
    }
}

// TextualSkinning Implementation
public struct TextualSkin: ViewSkinning {
    public var configID: String
    public var font: Font
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // TextualSkinning protocol implementation
    public init(configID: String, font: Font, color: ColourfulSkinning? = nil, size: SizableSkinning? = nil) {
        self.configID = configID
        self.font = font
        self.color = color
        self.size = size
    }
    public static var `default`: TextualSkin {
        TextualSkin(
            configID: "application_core_ui_views_default_text_skin",
            font: .title,
            color: ColourfulSkin(
                backgroundColor: .orange,
                foreGroundColor: .black,
                borderColor: .red
            ),
            size: SizableSkin(
                borderWidth: 2,
                cornerRadius: 5,
                width: 100,
                height: 100,
                padding: .init(
                    top: 5,
                    left: 5,
                    bottom: 5,
                    right: 5
                )
            )
        )
    }
}
