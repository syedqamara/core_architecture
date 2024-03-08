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

extension UIEdgeInsets {
    public static var defaultPaddingValue: CGFloat = 5
    public static func padding(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: value, bottom: value, right: value)
    }
    public static func padding(top: CGFloat = Self.defaultPaddingValue, left: CGFloat = Self.defaultPaddingValue, bottom: CGFloat = Self.defaultPaddingValue, right: CGFloat = Self.defaultPaddingValue) -> UIEdgeInsets {
        .init(top: top, left: left, bottom: bottom, right: right)
    }
    public static func padding(verticle: CGFloat = Self.defaultPaddingValue, horizontal: CGFloat = Self.defaultPaddingValue) -> UIEdgeInsets {
        .init(top: verticle, left: horizontal, bottom: verticle, right: horizontal)
    }
}

// SizableSkinning Implementation
public struct SizableSkin: SizableSkinning {
    public var borderWidth: CGFloat = 0
    public var cornerRadius: CGFloat = 0
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var padding: UIEdgeInsets = .padding()
    public init(borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0, width: CGFloat = -1, height: CGFloat = -1, padding: UIEdgeInsets = .padding(UIEdgeInsets.defaultPaddingValue)) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
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
    public init(backgroundColor: UIColor = .clear, foreGroundColor: UIColor = .clear, tintColor: UIColor = .clear, borderColor: UIColor = .clear) {
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
        .init(
            configID: "ViewSkin.default.SkinID",
            color: ColourfulSkin(
                backgroundColor: .green,
                foreGroundColor: .blue
            ),
            size: SizableSkin(
                width: 200,
                height: 100
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
    public init(configID: String = "TextualSkin.SkinID", font: Font = .body, color: ColourfulSkinning? = ColourfulSkin.default, size: SizableSkinning? = SizableSkin.default) {
        self.configID = configID
        self.font = font
        self.color = color
        self.size = size
    }
    public static var `default`: TextualSkin {
        .init(
            configID: "TextualSkin.default.SkinID",
            font: .title3,
            color: ColourfulSkin(
                backgroundColor: .systemPink,
                foreGroundColor: .black
            ),
            size: SizableSkin(
                width: 200,
                height: 50
            )
        )
    }
}


// VStackSkin Implementation
public struct VStackSkin: ViewSkinning {
    public var configID: String
    public var spacing: CGFloat
    public var alignment: HorizontalAlignment = .center
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // TextualSkinning protocol implementation
    public init(configID: String = "VStackSkin.SkinID", spacing: CGFloat = 0, alignment: HorizontalAlignment = .center, color: ColourfulSkinning? = ColourfulSkin.default, size: SizableSkinning? = SizableSkin.default) {
        self.configID = configID
        self.spacing = spacing
        self.alignment = alignment
        self.color = color
        self.size = size
    }
    public static var `default`: VStackSkin {
        .init(
            configID: "VStackSkin.default.SkinID",
            spacing: 10,
            alignment: .center,
            color: ColourfulSkin(
                backgroundColor: .yellow,
                foreGroundColor: .blue
            ),
            size: SizableSkin(
                width: -1,
                height: -1
            )
        )
    }
}
// HStackSkin Implementation
public struct HStackSkin: ViewSkinning {
    public var configID: String
    public var spacing: CGFloat
    public var alignment: VerticalAlignment = .center
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // TextualSkinning protocol implementation
    public init(configID: String = "HStackSkin.SkinID", spacing: CGFloat = 0, alignment: VerticalAlignment = .center, color: ColourfulSkinning? = ColourfulSkin.default, size: SizableSkinning? = SizableSkin.default) {
        self.configID = configID
        self.spacing = spacing
        self.alignment = alignment
        self.color = color
        self.size = size
    }
    public static var `default`: HStackSkin {
        .init(
            configID: "HStackSkin.default.SkinID",
            spacing: 10,
            alignment: .center,
            color: ColourfulSkin(
                backgroundColor: .yellow,
                foreGroundColor: .blue
            ),
            size: SizableSkin(
                width: 200,
                height: 50
            )
        )
    }
}

// HStackSkin Implementation
public struct ZStackSkin: ViewSkinning {
    public var configID: String
    public var alignment: Alignment = .center
    public var color: ColourfulSkinning?
    public var size: SizableSkinning?
    // TextualSkinning protocol implementation
    public init(configID: String = "ZStackSkin.SkinID", alignment: Alignment = .center, color: ColourfulSkinning? = ColourfulSkin.default, size: SizableSkinning? = SizableSkin.default) {
        self.configID = configID
        self.alignment = alignment
        self.color = color
        self.size = size
    }
    public static var `default`: ZStackSkin {
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
