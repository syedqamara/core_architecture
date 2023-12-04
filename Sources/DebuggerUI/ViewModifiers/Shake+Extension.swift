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
    @objc func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        #if os(iOS)
        guard motion == .motionShake else { return }
        NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        #endif
    }
    @objc func didShake(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        #if os(iOS)
        guard motion == .motionShake else { return }
        NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        #endif
    }
    static func swizzleMotionMethods() {
        let originalMotionEndedSelector = #selector(motionEnded(_:with:))
        let swizzledMotionEndedSelector = #selector(didShake(_:with:))
        
        guard
            let originalMotionEndedMethod = class_getInstanceMethod(UIResponder.self, originalMotionEndedSelector),
            let swizzledMotionEndedMethod = class_getInstanceMethod(UIResponder.self, swizzledMotionEndedSelector)
        else {
            return
        }
        
        method_exchangeImplementations(originalMotionEndedMethod, swizzledMotionEndedMethod)
    }
}
#endif
struct ShakeGestureViewModifier: ViewModifier {
    let action: () -> Void
    init(action: @escaping () -> Void) {
        self.action = action
        UIResponder.swizzleMotionMethods()
    }
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
