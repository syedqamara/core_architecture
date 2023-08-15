//
//  View.swift
//
//
//  Created by Apple on 25/07/2023.
//

import Foundation
import SwiftUI
/**
 The SwiftUIView public protocol defines a generic interface for views that require a view model conforming to the ViewModeling public protocol. This public protocol is primarily intended for use in SwiftUI views to enable seamless integration of view models for data presentation and manipulation.

 Associated Type

 ViewModelType: The associated type representing the view model conforming to the ViewModeling public protocol. This view model provides the necessary data and behavior for the view.
 Initialization

 init(viewModel: ViewModelType): This required initializer is responsible for initializing the view with the provided view model. Conforming types should use this initializer to set up the view and bind its properties to the corresponding properties in the view model.
 
// Define a view model conforming to ViewModeling public protocol
class UserProfileViewModel: ViewModeling {
    // ViewModeling public protocol implementation
}

// Conform to the SwiftUIView using UserProfileViewModel as the view model
struct UserProfileView: SwiftUIView {
    typealias ViewModelType = UserProfileViewModel

    // View implementation using UserProfileViewModel as the view model
    init(viewModel: UserProfileViewModel) {
        // Initialize the view and set up bindings with the view model
    }
}
*/
// MARK: - SwiftUIView
/// The `SwiftUIView` defines a generic interface for views that require a view model conforming to the `ViewModeling` public protocol.
/// This public protocol is intended for use in SwiftUI views to enable seamless integration of view models for data presentation and manipulation.
// sourcery: AutoMockable
public protocol SwiftUIView: ViewProtocol, View {
    
}

