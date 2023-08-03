//
//  Module.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

// MARK: - Moduling
/// The `Moduling` public protocol represents a modular component that can be instantiated with a specific input, denoted by the associated type `ModuleInput`.
/// This public protocol is designed to facilitate the creation of modular components that can encapsulate functionality and be configured with input data as needed.
// sourcery: AutoMockable
public protocol Moduling {
    /// The associated type representing the input data required to configure the module.
    ///
    /// The `ModuleInput` type defines the data needed to initialize and configure the module with specific functionality or behavior.
    ///
    /// Example Usage:
    ///
    ///     // Define a struct representing module input
    ///     struct UserProfileInput {
    ///         var userID: Int
    ///     }
    ///
    ///     // Conform to the Moduling public protocol using UserProfileInput as the module input type
    ///     struct UserProfileModule: Moduling {
    ///         typealias ModuleInput = UserProfileInput
    ///
    ///         // Moduling public protocol implementation using UserProfileInput as module input
    ///     }
    ///
    /// In the above example, we define a `UserProfileInput` struct that represents the input data required to configure a user profile module. Then, we create a `UserProfileModule` struct conforming to the `Moduling` public protocol, specifying `UserProfileInput` as the associated module input type. The module can now be instantiated with specific `UserProfileInput` data to provide personalized user profile functionality.
    ///
    associatedtype ModuleInput

    /// Initializes the module with the provided input data.
    ///
    /// - Parameter input: The input data used to configure the module.
    ///
    /// Conforming types should use this initializer to set up the module based on the provided `input`.
    ///
    /// Example Usage:
    ///
    ///     // Define a struct representing module input
    ///     struct UserProfileInput {
    ///         var userID: Int
    ///     }
    ///
    ///     // Conform to the Moduling public protocol using UserProfileInput as the module input type
    ///     struct UserProfileModule: Moduling {
    ///         typealias ModuleInput = UserProfileInput
    ///
    ///         init(input: UserProfileInput) {
    ///             // Initialize the module and configure it with the provided input
    ///         }
    ///     }
    ///
    /// In the above example, we create a `UserProfileModule` struct conforming to the `Moduling` public protocol. The `init(input:)` initializer in `UserProfileModule` allows the module to be initialized and configured with the provided `UserProfileInput`. The module can then use the input data to set up specific functionality related to the user profile.
    ///
    init(input: ModuleInput)
}
