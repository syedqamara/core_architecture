//
//  File 2.swift
//  
//
//  Created by Apple on 28/11/2023.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI
import Debugger

extension Notification.Name {
    static let deviceDidShake = Notification.Name(rawValue: "deviceDidShake")
}
#if os(iOS)
extension UIResponder {
    open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        #if os(iOS)
        guard motion == .motionShake else { return }
        NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        #endif
    }
}
#endif
struct ShakeGestureViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
                action()
            }
    }
}

extension View {
    public func onShakeGesture(perform action: @escaping () -> Void) -> some View {
        #if os(iOS)
        return self.modifier(ShakeGestureViewModifier(action: action))
        #elseif os(macOS)
        // Shake gesture handling for macOS can be implemented using NSEvent
        return self.onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
            action()
        }
        #endif
    }
}
