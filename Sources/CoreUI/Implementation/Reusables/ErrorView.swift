//
//  ErrorView.swift
//  AppStoreManager
//
//  Created by Apple on 19/02/2024.
//


import SwiftUI

struct ErrorViewModifier: ViewModifier {
    @Binding var error: String?
    
    func body(content: Content) -> some View {
        VStack {
            content
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 4)
            }
        }
    }
}

extension View {
    func showError(_ error: Binding<String?>) -> some View {
        self.modifier(ErrorViewModifier(error: error))
    }
}
