//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation
import Core

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
        NoView(viewModel: .init(), skin: .init(configID: "No_View_Config_ID"))
    }
}

/// A private class representing a view model for a view.
private class NoViewModel: ViewModeling {}

/// A struct representing a view that conforms to the `ViewProtocol` protocol.
private struct NoView: ViewProtocol {
    
    
    public typealias SkinType = NoViewTheme
    
    public typealias ViewModelType = NoViewModel
    
    /// Creates a `NoView` with the provided view model.
    ///
    /// - Parameter viewModel: The view model for the view.
    /// - Parameter skin: The view's skin (i.e colors, sizes, paddings, fonts)
    init(viewModel: NoViewModel, skin: NoViewTheme) {
        // implement logic using `viewModel` and `skin`
    }
}
extension NoView {
    struct NoViewTheme: Skinning {
        static var `default`: NoView.NoViewTheme {.init(configID: "")}
        
        var configID: String
    }
}
