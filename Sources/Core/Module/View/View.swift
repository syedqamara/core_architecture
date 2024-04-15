//
//  View.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
/**
 The ViewProtocol public protocol defines a generic interface for views that require a view model conforming to the ViewModeling public protocol. This public protocol is primarily intended for use in SwiftUI views to enable seamless integration of view models for data presentation and manipulation.

 Associated Type

 ViewModelType: The associated type representing the view model conforming to the ViewModeling public protocol. This view model provides the necessary data and behavior for the view.
 Initialization

 init(viewModel: ViewModelType): This required initializer is responsible for initializing the view with the provided view model. Conforming types should use this initializer to set up the view and bind its properties to the corresponding properties in the view model.
 
// Define a view model conforming to ViewModeling public protocol
class UserProfileViewModel: ViewModeling {
    // ViewModeling public protocol implementation
}

// Conform to the ViewProtocol using UserProfileViewModel as the view model
struct UserProfileView: ViewProtocol {
    typealias ViewModelType = UserProfileViewModel

    // View implementation using UserProfileViewModel as the view model
    init(viewModel: UserProfileViewModel) {
        // Initialize the view and set up bindings with the view model
    }
}
*/
// MARK: - ViewProtocol
/// The `ViewProtocol` defines a generic interface for views that require a view model conforming to the `ViewModeling` public protocol.
/// This public protocol is intended for use in SwiftUI views to enable seamless integration of view models for data presentation and manipulation.
// sourcery: AutoMockable
public protocol ViewProtocol {
    /// The associated type representing the view model conforming to the `ViewModeling` public protocol.
    associatedtype ViewModelType: ViewModeling
    
    
    

    /// Initializes the view with the provided view model.
    ///
    /// - Parameter viewModel: The view model instance conforming to `ViewModeling`.
    ///
    /// Conforming types should use this initializer to set up the view and bind its properties to the corresponding properties in the view model.
    ///
    /// Example Usage:
    ///
    ///     // Define a view model conforming to ViewModeling public protocol
    ///     class UserProfileViewModel: ViewModeling {
    ///         // ViewModeling public protocol implementation
    ///     }
    ///
    ///     // Conform to the ViewProtocol using UserProfileViewModel as the view model
    ///     struct UserProfileView: ViewProtocol {
    ///         typealias ViewModelType = UserProfileViewModel
    ///
    ///         // View implementation using UserProfileViewModel as the view model
    ///         init(viewModel: UserProfileViewModel) {
    ///             // Initialize the view and set up bindings with the view model
    ///         }
    ///     }
    ///
    /// In the above example, we create a `UserProfileViewModel` class conforming to the `ViewModeling` public protocol, which serves as the view model for the user profile view. We then define a `UserProfileView` struct that conforms to the `ViewProtocol`, using `UserProfileViewModel` as the associated view model type. The `init(viewModel:)` initializer in `UserProfileView` allows the view to initialize itself with the provided view model, enabling the view to reactively update its content based on the changes in the view model.
    ///
    /// By adopting the `ViewProtocol`, SwiftUI views can seamlessly integrate view models, promoting a clear separation of concerns and enabling reactive user interfaces.
    ///
    
}

