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
    public var borderWidth: CGFloat = 0
    public var cornerRadius: CGFloat = 0
    public var configID: String = ""
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var padding: UIEdgeInsets = .init()
    public init(configID: String = "SizableSkin.default.SkinID", borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0, width: CGFloat = -1, height: CGFloat = -1, padding: UIEdgeInsets = .zero) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.configID = configID
        self.width = width
        self.height = height
        self.padding = padding
    }
    public static var `default`: Self { .init() }
    // SizableSkinning protocol implementation
}


// ColourfulSkinning Implementation
public struct ColourfulSkin: ColourfulSkinning {
    public var backgroundColor: UIColor = .clear
    public var foreGroundColor: UIColor = .clear
    public var configID: String = ""
    public var tintColor: UIColor = .clear
    public var borderColor: UIColor = .clear
    // ColourfulSkinning protocol implementation
    public init(configID: String = "ColourfulSkin.default.SkinID", backgroundColor: UIColor = .clear, foreGroundColor: UIColor = .clear, tintColor: UIColor = .clear, borderColor: UIColor = .clear) {
        self.configID = configID
        self.backgroundColor = backgroundColor
        self.foreGroundColor = foreGroundColor
        self.tintColor = tintColor
        self.borderColor = borderColor
    }
    public static var `default`: ColourfulSkin { .init() }
}

// ViewSkinning Implementation
public struct ViewSkin: ViewSkinning {
    public var configID: String
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // ViewSkinning protocol implementation
    public init(configID: String = "ViewSkin.SkinID", color: ColourfulSkinning? = ColourfulSkin.default, size: SizableSkinning? = SizableSkin.default) {
        self.configID = configID
        self.color = color
        self.size = size
    }
    public static var `default`: ViewSkin {
        .init()
    }
}

// TextualSkinning Implementation
public struct TextualSkin: ViewSkinning {
    public var configID: String
    public var font: Font
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // TextualSkinning protocol implementation
    public init(configID: String = "TextualSkin.SkinID", font: Font = .body, color: ColourfulSkinning? = ColourfulSkin.default, size: SizableSkinning? = SizableSkin.default) {
        self.configID = configID
        self.font = font
        self.color = color
        self.size = size
    }
    public static var `default`: TextualSkin {
        .init()
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
    public init(configID: String = "ImageSkin.SkinID", font: Font = .body, contentMode: ContentMode = .fit, color: ColourfulSkinning? = nil, size: SizableSkinning? = nil) {
        self.configID = configID
        self.font = font
        self.contentMode = contentMode
        self.color = color
        self.size = size
    }
    public static var `default`: ImageSkin {
        .init()
    }
}
