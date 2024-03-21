//
//  File.swift
//  
//
//  Created by Apple on 17/02/2024.
//

import Foundation
import Core
import Dependencies

/// A concrete implementation of `ViewingFactory`.
public struct ViewFactory: ViewingFactory {
    /// Creates an instance of `ViewFactory`.
    public init() {}

    var isPreview: Bool {
        if let xcPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] {
            return xcPreview == "1"
        }
        return false
    }
    
    /// Creates a `NoView` with a default view model.
    public func makeView<I>(input: I) -> any ViewProtocol {
        fatalError("Implement Sepacialised version of this method.")
    }
    public func swiftUIView<I>(input: I) -> any SwiftUIView {
        fatalError("Implement Sepacialised version of this method.")
    }
}
extension ViewFactory: DependencyKey, TestDependencyKey {
    public static var liveValue: ViewFactory = ViewFactory()
    public static var testValue: ViewFactory = ViewFactory()
}

public extension DependencyValues {
    var viewFactory: ViewFactory {
        get {
            self[ViewFactory.self]
        }
        set {
            self[ViewFactory.self] = newValue
        }
    }
}
