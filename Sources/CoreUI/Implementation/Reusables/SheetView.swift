//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import SwiftUI

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
