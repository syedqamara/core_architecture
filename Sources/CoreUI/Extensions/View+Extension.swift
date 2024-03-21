//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func border(radius: CGFloat = 0, border: ColorInputType = .appThemePrimaryBorderColor, background: ColorInputType = .appThemePrimaryBackgroundColor) -> some View {
        self
        .background(
            VStack {
                RoundedRectangle(cornerRadius: radius)
                    .stroke(border.color.swiftUI, lineWidth: 2)
                    .background(background.color.swiftUI)
            }
        )
    }
    @ViewBuilder
    func foregroundColoring(_ color: ColorInputType) -> some View {
        self
            .foregroundStyle(color.color.swiftUI)
    }
}
