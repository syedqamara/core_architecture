//
//  File.swift
//  
//
//  Created by Apple on 30/01/2024.
//

import Foundation
import SwiftUI
import Core


// Apply Skin

extension View {
    @ViewBuilder
    public func skinTune(_ skin: ViewSkinning) -> some View {
        modifier(ViewSkinModifier(skin: skin))
    }
}

extension Text {
    @ViewBuilder
    public func skinTune(_ skin: TextualSkin) -> some View {
        modifier(TextSkinModifier(skin: skin))
    }
}
extension Image {
    @ViewBuilder
    public func skinTune(_ skin: ImageSkin) -> some View {
        if let width = skin.size?.width, width < 0 {
            nonResizableSkinTune(skin)
        }
        else if let height = skin.size?.height, height < 0 {
            nonResizableSkinTune(skin)
        }
        else if let size = skin.size {
            resizableSkinTune(skin)
        } else {
            nonResizableSkinTune(skin)
        }
    }
    
    @ViewBuilder
    fileprivate func resizableSkinTune(_ skin: ImageSkin) -> some View {
        self
            .resizable()
            .modifier(ViewSkinModifier(skin: skin))
    }
    
    @ViewBuilder
    fileprivate func nonResizableSkinTune(_ skin: ImageSkin) -> some View {
        self
            .font(skin.font)
            .modifier(ViewSkinModifier(skin: skin))
    }
}

extension TextField {
    @ViewBuilder
    public func skinTune(_ skin: TextualSkin) -> some View {
        modifier(TextSkinModifier(skin: skin))
    }
}
extension SecureField {
    @ViewBuilder
    public func skinTune(_ skin: TextualSkin) -> some View {
        modifier(TextSkinModifier(skin: skin))
    }
}

// View Modifier for Views
struct ViewSkinModifier: ViewModifier {
    var skin: ViewSkinning
    
    func width() -> CGFloat {
        if let size = skin.size {
            return size.width
        }
        return -1
    }
    func height() -> CGFloat {
        if let size = skin.size {
            return size.height
        }
        return -1
    }
    
    func body(content: Content) -> some View {
        return content
            .background(skin.color?.backgroundColor.swiftUI)
            .foregroundColor(skin.color?.foreGroundColor.swiftUI)
            .tint(skin.color?.tintColor.swiftUI)
            .frame(
                width: width() >= 0 ? width() : nil,
                height: height() >= 0 ? height() : nil
            )
            .padding(
                .init(skin.size?.padding)
            )
            .border(skin.color?.borderColor.swiftUI ?? .clear, width: skin.size?.borderWidth ?? 0)
    }
}

extension EdgeInsets {
    init(_ inset: UIEdgeInsets?) {
        if let inset {
            self.init(top: inset.top, leading: inset.left, bottom: inset.bottom, trailing: inset.right)
        }
        else {
            self.init()
        }
    }
}

// View Modifier for Text
struct TextSkinModifier: ViewModifier {
    var skin: TextualSkin

    func body(content: Content) -> some View {
        return content
            .font(skin.font)
            .modifier(ViewSkinModifier(skin: skin))
    }
}


// View Modifier for Text
struct RoundRectSkinModifier: ViewModifier {
    var skin: TextualSkin

    func body(content: Content) -> some View {
        return content
            .font(skin.font)
            .modifier(ViewSkinModifier(skin: skin))
    }
}

extension UIColor {
    public var swiftUI: Color {
        return Color(uiColor: self)
    }
}
