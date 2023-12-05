//
//  File 2.swift
//  
//
//  Created by Apple on 28/11/2023.
//

import Foundation
import UIKit
import SwiftUI
import Debugger

extension Notification.Name {
    static let deviceDidShake = Notification.Name(rawValue: "deviceDidShake")
}
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with: UIEvent?) {
        guard motion == .motionShake else { return }
        NotificationCenter.default.post(name: .deviceDidShake, object: nil)
  }
}

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
        return self.modifier(ShakeGestureViewModifier(action: action))
    }
}
