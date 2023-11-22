//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import Foundation

/// Protocol for a factory that creates views.
public protocol ViewingFactory {
    /// Creates a view of a specific type for a given input.
    ///
    /// - Parameter input: The input data for configuring the view.
    /// - Returns: An instance of a view that conforms to the `Viewing` protocol.
    func makeView<I>(input: I) -> any ViewProtocol
}

public struct ViewFactory: ViewingFactory {
    public init() {}
    
    public func makeView<I>(input: I) -> any ViewProtocol {
        NoView(viewModel: .init())
    }
    
}

private  class NoViewModel: ViewModeling {}

private struct NoView: ViewProtocol {
    public typealias ViewModelType = NoViewModel
    public init(viewModel: NoViewModel) {
        
    }
}
