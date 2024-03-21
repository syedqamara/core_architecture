//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
import SwiftUI

public struct RouteLink<D: View, R: View>: View {
    @State public var link: Bool = false
    public var display: () -> (D)
    public var route: () -> (R)
    init(display: @escaping () -> D, route: @escaping () -> R) {
        self.display = display
        self.route = route
    }
    
    public var body: some View {
        NavigationLink(destination: route(), isActive: $link, label: {
            display()
        })
        .isDetailLink(false)
        
    }
}

import SwiftUI

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
    
    public mutating func dismiss() {
        self.toggle()
        NavigationUtil.popToRootView(animated: true)
    }
}
struct NavigationUtil {
    static func popToRootView(animated: Bool = false) {
        findNavigationController(viewController: UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.rootViewController)?.popToRootViewController(animated: animated)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UITabBarController {
            return findNavigationController(viewController: navigationController.selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
