//
//  GeneralHelperView.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import SwiftUI

public struct RoundedBackgroundView<Content: View>: View {
    let content: Content
    let color: Color
    public init(@ViewBuilder content: () -> Content, color: Color = .black) {
        self.content = content()
        self.color = color
    }

    public var body: some View {
        content
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(color))
    }
}

public struct SheetView<Content: View>: View {
    @Environment(\.presentationMode) var dismiss
    let content: Content
    private let buttons: [String]
    private let onClick: (String) -> ()
    public init(@ViewBuilder content: () -> Content, buttons: [String], onClick: @escaping (String) -> ()) {
        self.content = content()
        self.onClick = onClick
        self.buttons = buttons
    }

    public var body: some View {
        VStack {
            content
            HStack {
                ForEach(buttons, id: \.self) { btn in
                    RoundedBackgroundView {
                        Text(btn)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                    .onTapGesture {
                        onClick(btn)
                        dismiss.wrappedValue.dismiss()
                    }

                }
            }
        }
        
    }
}

public struct TitleSubtitleView: View {
    let title: String
    let titleColor: Color
    let titleFont: Font
    let subtitle: String
    let subtitleColor: Color
    let subtitleFont: Font
    public init(title: String, subtitle: String, titleColor: Color = .gray, titleFont: Font = .title3.bold(), subtitleColor: Color = .white, subtitleFont: Font = .title3.bold()) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.subtitle = subtitle
        self.subtitleFont = subtitleFont
        self.subtitleColor = subtitleColor
    }
    public var body: some View {
        HStack {
            Text(title)
                .font(titleFont)
                .foregroundColor(titleColor)
            Spacer()
            Text(subtitle)
                .font(subtitleFont)
                .foregroundColor(subtitleColor)
        }
    }
}

extension View {
    public func separater(height: CGFloat = 1) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(.gray)
    }
}
