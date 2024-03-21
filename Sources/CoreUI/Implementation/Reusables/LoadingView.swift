//
//  LoadingView.swift
//  AppStoreManager
//
//  Created by Apple on 19/02/2024.
//


import SwiftUI

struct LoadingIndicatorModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .disabled(isLoading)
        .onTapGesture {
            // Prevent tap gestures when loading
        }
    }
}

extension View {
    func loading(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingIndicatorModifier(isLoading: isLoading))
    }
}
