//
//  View.swift
//
//
//  Created by Apple on 25/07/2023.
//

import Foundation
import UIKit
import Core


/**
 The `UIKitView` protocol extends the `ViewProtocol` and `UIView`, defining a generic interface for views that seamlessly integrate with view models conforming to the `ViewModeling` public protocol. This protocol is designed for use in UIKit-based applications, allowing for the integration of view models to handle data presentation and manipulation within individual views.

 ## Associated Type

 - `ViewModelType`: The associated type representing the view model conforming to the `ViewModeling` public protocol. This view model provides the necessary data and behavior for the view.

 ## Initialization

 - `init(viewModel: ViewModelType)`: This required initializer is responsible for initializing the view with the provided view model. Conforming types should use this initializer to set up the view and bind its properties to the corresponding properties in the view model.

 ## Example Usage:

 ```swift
 // Define a view model conforming to ViewModeling public protocol
 class UserProfileViewModel: ViewModeling {
     // ViewModeling public protocol implementation
 }

 // Conform to the UIKitView using UserProfileViewModel as the view model
 class UserProfileView: UIKitView {
     typealias ViewModelType = UserProfileViewModel

     // View implementation using UserProfileViewModel as the view model
     required init(viewModel: UserProfileViewModel) {
         super.init(frame: .zero)
         // Initialize the view and set up bindings with the view model
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 ```

 In the above example, we create a `UserProfileViewModel` class conforming to the `ViewModeling` public protocol, which serves as the view model for the user profile view. We then define a `UserProfileView` class that conforms to the `UIKitView`, using `UserProfileViewModel` as the associated view model type. The required `init(viewModel:)` initializer in `UserProfileView` allows the view to initialize itself with the provided view model, enabling the view to reactively update its content based on the changes in the view model.

 By adopting the `UIKitView` protocol, UIKit-based views can seamlessly integrate view models, promoting a clear separation of concerns and enabling reactive user interfaces within individual views.
 */
public protocol UIKitView: ViewProtocol, UIView {
    // Any additional requirements specific to UIKitView can be added here.
}


