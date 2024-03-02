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
    public static var `default`: Self { .init(configID: "SizableSkin.default.SkinID") }
    
    public var borderWidth: CGFloat = 0
    public var cornerRadius: CGFloat = 0
    public var configID: String = ""
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var padding: UIEdgeInsets = .init()
    public init(configID: String, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0, width: CGFloat = -1, height: CGFloat = -1, padding: UIEdgeInsets = .zero) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.configID = configID
        self.width = width
        self.height = height
        self.padding = padding
    }
    // SizableSkinning protocol implementation
}


// ColourfulSkinning Implementation
public struct ColourfulSkin: ColourfulSkinning {
    public static var `default`: ColourfulSkin { .init(configID: "ColourfulSkin.default.SkinID") }
    public var backgroundColor: UIColor = .clear
    public var foreGroundColor: UIColor = .clear
    public var configID: String = ""
    public var tintColor: UIColor = .clear
    public var borderColor: UIColor = .clear
    // ColourfulSkinning protocol implementation
    public init(configID: String, backgroundColor: UIColor = .clear, foreGroundColor: UIColor = .clear, tintColor: UIColor = .clear, borderColor: UIColor = .clear) {
        self.configID = configID
        self.backgroundColor = backgroundColor
        self.foreGroundColor = foreGroundColor
        self.tintColor = tintColor
        self.borderColor = borderColor
    }
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
            configID: "ViewSkin.SkinID",
            color: ColourfulSkin(
                configID: "ViewSkin.color.SkinID"
            ),
            size: SizableSkin(
                configID: "ViewSkin.color.SkinID"
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
            configID: "TextualSkin.SkinID",
            font: .title,
            color: ColourfulSkin(
                configID: "TextualSkin.color.SkinID"
            ),
            size: SizableSkin(
                configID: "TextualSkin.color.SkinID"
            )
        )
    }
}

// ImageSkinning Implementation
public struct ImageSkin: ViewSkinning {
    public var configID: String
    public var font: Font
    public var contentMode: ContentMode
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // TextualSkinning protocol implementation
    public init(configID: String, font: Font, contentMode: ContentMode, color: ColourfulSkinning? = nil, size: SizableSkinning? = nil) {
        self.configID = configID
        self.font = font
        self.contentMode = contentMode
        self.color = color
        self.size = size
    }
    public static var `default`: ImageSkin {
        ImageSkin(
            configID: "ImageSkin.SkinID",
            font: .title,
            contentMode: .fit,
            color: ColourfulSkin(
                configID: "ImageSkin.color.SkinID"
            ),
            size: SizableSkin(
                configID: "ImageSkin.color.SkinID"
            )
        )
    }
}
