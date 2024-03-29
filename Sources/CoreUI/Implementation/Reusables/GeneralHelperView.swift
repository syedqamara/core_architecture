//
//  GeneralHelperView.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import SwiftUI

public struct TitleSubtitleView: View {
    let title: String
    let titleColor: Color
    let titleFont: Font
    let subtitle: String
    let subtitleColor: Color
    let subtitleFont: Font
    public init(title: String, subtitle: String, titleColor: Color = .gray, titleFont: Font = .subheadline.bold(), subtitleColor: Color = .white, subtitleFont: Font = .subheadline.bold()) {
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

public extension View {
    func separater(height: CGFloat = 1) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(.gray)
    }
}
