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

public struct AppView<V: View>: View {
    public enum AppScreens {
    case application, breakpoint
    }
    public let startScreen: AppScreens
    private var applicationView: V
    public init(startScreen: AppScreens, @ViewBuilder applicationView: () -> V) {
        self.startScreen = startScreen
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
            switch startScreen {
            case .application:
                applicationView
            case .breakpoint:
                AnyView(
                    viewFactory.swiftUIView(
                        input: startScreen
                    )
                )
            }
        }
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
