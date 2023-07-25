//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

// MARK: - ViewModule
/// The `ViewModule` protocol represents a view module that conforms to the `Moduling` protocol and specifies an associated type for the view it manages, denoted by `ViewType`.
/// This protocol is designed to encapsulate the logic and configuration of a specific SwiftUI view, allowing for modular and reusable view components.

protocol ViewModule: Moduling {
    /// The associated type representing the SwiftUI view managed by the view module.
    ///
    /// The `ViewType` should conform to the `ViewProtocol`, enabling the seamless integration of view models with SwiftUI views.
    ///
    /// Example Usage:
    ///
    ///     // Define a SwiftUI view conforming to ViewProtocol
    ///     struct UserProfileView: ViewProtocol {
    ///         // ViewProtocol implementation
    ///     }
    ///
    ///     // Conform to the ViewModule using UserProfileView as the associated view type
    ///     class UserProfileModule: ViewModule {
    ///         typealias ViewType = UserProfileView
    ///
    ///         // ViewModule protocol implementation using UserProfileView as the view type
    ///     }
    ///
    /// In the above example, we define a `UserProfileView` struct conforming to the `ViewProtocol`, which represents a SwiftUI view that can be managed by a view module. Then, we create a `UserProfileModule` class conforming to the `ViewModule` protocol, specifying `UserProfileView` as the associated view type. The view module can now encapsulate the logic and configuration of the `UserProfileView`, providing a reusable and modular SwiftUI view component.
    ///
    associatedtype ViewType: ViewProtocol

    /// Returns the configured SwiftUI view managed by the view module.
    ///
    /// - Returns: An instance of the SwiftUI view conforming to `ViewType`.
    ///
    /// Conforming types should implement this method to return an instance of the SwiftUI view, properly configured with its respective view model and any other required dependencies.
    ///
    /// Example Usage:
    ///
    ///     // Define a SwiftUI view conforming to ViewProtocol
    ///     struct UserProfileView: ViewProtocol {
    ///         // ViewProtocol implementation
    ///     }
    ///
    ///     // Conform to the ViewModule using UserProfileView as the associated view type
    ///     class UserProfileModule: ViewModule {
    ///         typealias ViewType = UserProfileView
    ///
    ///         func view() -> UserProfileView {
    ///             // Configure and return an instance of UserProfileView
    ///             let viewModel = UserProfileViewModel() // Assuming UserProfileViewModel is a view model conforming to ViewModeling protocol
    ///             return UserProfileView(viewModel: viewModel)
    ///         }
    ///     }
    ///
    /// In the above example, we create a `UserProfileModule` class conforming to the `ViewModule` protocol. The `view()` method is implemented to configure and return an instance of `UserProfileView`, ensuring that it is properly initialized with its corresponding view model. The method enables the view module to manage the creation and configuration of the SwiftUI view, facilitating reusability and separation of concerns.
    ///
    func view() -> ViewType
}
