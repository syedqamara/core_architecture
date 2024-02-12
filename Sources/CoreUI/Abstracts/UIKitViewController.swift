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
 The `UIKitViewController` protocol extends the `ViewProtocol` and `UIViewController`, providing a generic interface for view controllers that seamlessly integrate with view models conforming to the `ViewModeling` public protocol. This protocol is designed for use in UIKit-based applications, allowing for the integration of view models to handle data presentation and manipulation.

 ## Associated Type

 - `ViewModelType`: The associated type representing the view model conforming to the `ViewModeling` public protocol. This view model provides the necessary data and behavior for the view controller.

 ## Initialization

 - `init(viewModel: ViewModelType)`: This required initializer is responsible for initializing the view controller with the provided view model. Conforming types should use this initializer to set up the view controller and bind its properties to the corresponding properties in the view model.

 ## Example Usage:

 ```swift
 // Define a view model conforming to ViewModeling public protocol
 class UserProfileViewModel: ViewModeling {
     // ViewModeling public protocol implementation
 }

 // Conform to the UIKitViewController using UserProfileViewModel as the view model
 class UserProfileViewController: UIKitViewController {
     typealias ViewModelType = UserProfileViewModel

     // View controller implementation using UserProfileViewModel as the view model
     required init(viewModel: UserProfileViewModel) {
         super.init(nibName: nil, bundle: nil)
         // Initialize the view controller and set up bindings with the view model
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 ```

 In the above example, we create a `UserProfileViewModel` class conforming to the `ViewModeling` public protocol, which serves as the view model for the user profile view controller. We then define a `UserProfileViewController` class that conforms to the `UIKitViewController`, using `UserProfileViewModel` as the associated view model type. The required `init(viewModel:)` initializer in `UserProfileViewController` allows the view controller to initialize itself with the provided view model, enabling the view controller to reactively update its content based on the changes in the view model.

 By adopting the `UIKitViewController` protocol, UIKit-based view controllers can seamlessly integrate view models, promoting a clear separation of concerns and enabling reactive user interfaces in applications.
 */
public protocol UIKitViewController: ViewProtocol, UIViewController {
    // Any additional requirements specific to UIKitViewController can be added here.
}

