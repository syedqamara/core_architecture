//
//  ViewModel.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation
/**
 The `ViewModeling` public protocol represents a view model that conforms to the `ObservableObject` public protocol and uses specific types for data source and UI model.
 
 This public protocol inherits from the `ObservableObject` public protocol, allowing conforming types to be used as view models in SwiftUI, facilitating reactive UI updates when the data changes.
 
 ## Associated Types
 - `DataSourceType`: The type representing the data source that conforms to the `DataSourcing` public protocol. The data source provides the underlying data used by the view model.
 - `UIModelType`: The type representing the UI model that conforms to the `UIModel` public protocol. The UI model is tailored for presenting data to the user interface.
 
 Example Usage:
 // Define a data source conforming to DataSourcing public protocol
 struct UserData: DataSourcing {
     // Data source implementation
 }
 
 // Define a UI model conforming to UIModel public protocol
struct UserUIModel: UIModel {
    // UI model implementation
}
 
 // Conform to the ViewModeling public protocol using UserData as the data source and UserUIModel as the UI model
class UserProfileViewModel: ViewModeling {
    typealias DataSourceType = UserData
    typealias UIModelType = UserUIModel
    // View model implementation using UserData as data source and UserUIModel as UI model
}
 In the above example, we define a `UserData` struct conforming to the `DataSourcing` public protocol, which provides the underlying data for the view model. Then, we define a `UserUIModel` struct conforming to the `UIModel` public protocol, which presents the user data to the user interface. Next, we create a `UserProfileViewModel` class conforming to the `ViewModeling` public protocol, using `UserData` as the data source and `UserUIModel` as the UI model. The view model can now use the `UserData` type to fetch and update data and `UserUIModel` type to present the data for display in the user interface.

 By using the `ViewModeling` public protocol, we can enforce that our view models are observable objects and have specific types for data source and UI model, making the architecture more structured and easier to maintain.
 **/

// MARK: - ViewModeling
/// The `ViewModeling` public protocol represents a view model that conforms to the `ObservableObject` public protocol and specifies associated types for data source and UI model.
/// This public protocol is designed to be used as a foundation for SwiftUI view models, enabling reactive UI updates when the underlying data changes.
// sourcery: AutoMockable
public protocol ViewModeling: AnyObject, ObservableObject {
    
}

public protocol CommandableViewModeling: ViewModeling {
    var executor: any CommandExecuting { get }
}
