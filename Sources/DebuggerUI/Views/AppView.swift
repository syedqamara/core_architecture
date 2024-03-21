//
//  File.swift
//  
//
//  Created by Apple on 17/02/2024.
//

import Foundation
import SwiftUI
import Dependencies
import Core
import CoreUI
import Debugger

public struct AppView<V: View>: View {
    private var applicationView: V
    @State private var networkDebugAction: NetworkDebuggerActions? = nil
    @State private var selectedCommand: ApplicationDebugCommands = .application
    @State private var isDebugViewShowing: Bool = false
    
    public init(@ViewBuilder applicationView: () -> V) {
        self.applicationView = applicationView()
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    @Dependency(\.viewFactory) var viewFactory
    public var body: some View {
        NavigationUI {
            switch selectedCommand {
            case .application:
                applicationView
            case .debugger:
                AnyView(
                    viewFactory.swiftUIView(
                        input: .breakpoint
                    )
                )
            }
        }
        .modifier(DebugShakeGestureModifier(selectedCommand: $selectedCommand, isShowing: $isDebugViewShowing, networkDebugAction: $networkDebugAction))
        .background(.black)
    }
}

//
//public struct NYTimesAppView_Previews: PreviewProvider {
//    public static var previews: some View {
//        snapshots.previews.previewLayout(.sizeThatFits)
//    }
//    public static var snapshots: Previewer<AppView.AppScreens> {
//        .init(
//            configurations: [
//                .init(name: "Preview App while Loading", state: .list(isLoading: true, error: nil, articles: [])),
//                .init(name: "Preview App with Error", state: .list(isLoading: false, error: "This is just a preview error", articles: [])),
//                .init(name: "Preview App with Article", state: .list(isLoading: false, error: nil, articles: [.init(dataModel: .preview), .init(dataModel: .preview), .init(dataModel: .preview)]))
//            ]) { input in
//                NYTimesAppView(startScreen: input)
//            }
//    }
//
//}
