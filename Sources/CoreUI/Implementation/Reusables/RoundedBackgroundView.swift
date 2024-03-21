//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
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
