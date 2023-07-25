//
//  ViewModel.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
/**
 The `ViewModeling` protocol represents a view model that conforms to the `ObservableObject` protocol and uses specific types for data source and UI model.
 
 This protocol inherits from the `ObservableObject` protocol, allowing conforming types to be used as view models in SwiftUI, facilitating reactive UI updates when the data changes.
 
 ## Associated Types
 - `DataSourceType`: The type representing the data source that conforms to the `DataSourcing` protocol. The data source provides the underlying data used by the view model.
 - `UIModelType`: The type representing the UI model that conforms to the `UIModel` protocol. The UI model is tailored for presenting data to the user interface.
 
 Example Usage:
 // Define a data source conforming to DataSourcing protocol
 struct UserData: DataSourcing {
     // Data source implementation
 }
 
 // Define a UI model conforming to UIModel protocol
struct UserUIModel: UIModel {
    // UI model implementation
}
 
 // Conform to the ViewModeling protocol using UserData as the data source and UserUIModel as the UI model
class UserProfileViewModel: ViewModeling {
    typealias DataSourceType = UserData
    typealias UIModelType = UserUIModel
    // View model implementation using UserData as data source and UserUIModel as UI model
}
 In the above example, we define a `UserData` struct conforming to the `DataSourcing` protocol, which provides the underlying data for the view model. Then, we define a `UserUIModel` struct conforming to the `UIModel` protocol, which presents the user data to the user interface. Next, we create a `UserProfileViewModel` class conforming to the `ViewModeling` protocol, using `UserData` as the data source and `UserUIModel` as the UI model. The view model can now use the `UserData` type to fetch and update data and `UserUIModel` type to present the data for display in the user interface.

 By using the `ViewModeling` protocol, we can enforce that our view models are observable objects and have specific types for data source and UI model, making the architecture more structured and easier to maintain.
 **/

// MARK: - ViewModeling
/// The `ViewModeling` protocol represents a view model that conforms to the `ObservableObject` protocol and specifies associated types for data source and UI model.
/// This protocol is designed to be used as a foundation for SwiftUI view models, enabling reactive UI updates when the underlying data changes.

protocol ViewModeling: AnyObject, ObservableObject {
    /// The associated type representing the data source used by the view model.
    ///
    /// The `DataSourceType` should conform to the `DataSourcing` protocol, providing the underlying data used by the view model for presentation and manipulation.
    ///
    /// Example Usage:
    ///
    ///     // Define a struct conforming to DataSourcing protocol
    ///     struct UserData: DataSourcing {
    ///         // Data source implementation
    ///     }
    ///
    ///     // Conform to the ViewModeling protocol using UserData as the data source type
    ///     class UserProfileViewModel: ViewModeling {
    ///         typealias DataSourceType = UserData
    ///
    ///         // ViewModeling protocol implementation using UserData as data source
    ///     }
    ///
    /// In the above example, we define a `UserData` struct conforming to the `DataSourcing` protocol, which provides the underlying data for the view model. Then, we create a `UserProfileViewModel` class conforming to the `ViewModeling` protocol, specifying `UserData` as the associated data source type. The view model can now use the `UserData` type to fetch and update data for the SwiftUI views.
    ///
    associatedtype DataSourceType

    /// The associated type representing the UI model used by the view model.
    ///
    /// The `UIModelType` should conform to the `UIModel` protocol, presenting the data from the data source for display in the user interface.
    ///
    /// Example Usage:
    ///
    ///     // Define a struct conforming to UIModel protocol
    ///     struct UserUIModel: UIModel {
    ///         // UI model implementation
    ///     }
    ///
    ///     // Conform to the ViewModeling protocol using UserUIModel as the UI model type
    ///     class UserProfileViewModel: ViewModeling {
    ///         typealias UIModelType = UserUIModel
    ///
    ///         // ViewModeling protocol implementation using UserUIModel as UI model
    ///     }
    ///
    /// In the above example, we define a `UserUIModel` struct conforming to the `UIModel` protocol, which is tailored for presenting user data to the user interface. Then, we create a `UserProfileViewModel` class conforming to the `ViewModeling` protocol, specifying `UserUIModel` as the associated UI model type. The view model can now use the `UserUIModel` type to format and transform the data for display in the SwiftUI views.
    ///
    associatedtype UIModelType: UIModel
}
