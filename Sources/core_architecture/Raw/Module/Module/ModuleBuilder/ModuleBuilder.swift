//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation
import SwiftUI

/// A protocol for factories that create SwiftUI views based on input data.
public protocol SwiftUIViewFactoryProtocol {
    /// Creates a view of a specific type for a given input.
    ///
    /// - Parameter input: The input data for configuring the view.
    /// - Returns: An instance of a view that conforms to the `SwiftUIView` protocol.
    func makeView<I>(input: I) -> any SwiftUIView
}

/// A concrete implementation of `SwiftUIViewFactoryProtocol`.
public struct SwiftUIViewFactory: SwiftUIViewFactoryProtocol {
    /// Creates an instance of `SwiftUIViewFactory`.
    public init() {}

    /// Creates a `NoSwiftUIView` with a default view model.
    public func makeView<I>(input: I) -> any SwiftUIView {
        NoSwiftUIView(viewModel: .init())
    }
}

/// A protocol for factories that create views based on input data.
public protocol ViewingFactory {
    /// Creates a view of a specific type for a given input.
    ///
    /// - Parameter input: The input data for configuring the view.
    /// - Returns: An instance of a view that conforms to the `ViewProtocol` protocol.
    func makeView<I>(input: I) -> any ViewProtocol
}

/// A concrete implementation of `ViewingFactory`.
public struct ViewFactory: ViewingFactory {
    /// Creates an instance of `ViewFactory`.
    public init() {}

    /// Creates a `NoView` with a default view model.
    public func makeView<I>(input: I) -> any ViewProtocol {
        NoView(viewModel: .init())
    }
}

/// A private class representing a view model for a view.
private class NoViewModel: ViewModeling {}

/// A struct representing a view that conforms to the `ViewProtocol` protocol.
private struct NoView: ViewProtocol {
    public typealias ViewModelType = NoViewModel
    
    /// Creates a `NoView` with the provided view model.
    ///
    /// - Parameter viewModel: The view model for the view.
    public init(viewModel: NoViewModel) {}
}

/// A struct representing a SwiftUI view that conforms to the `SwiftUIView` protocol.
private struct NoSwiftUIView: SwiftUIView {
    public typealias ViewModelType = NoViewModel
    
    /// Creates a `NoSwiftUIView` with the provided view model.
    ///
    /// - Parameter viewModel: The view model for the SwiftUI view.
    public init(viewModel: NoViewModel) {}
    
    /// The body of the SwiftUI view.
    public var body: some View {
        Text("")
    }
}
