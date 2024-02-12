//
//  UIModel.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

// MARK: - Data Model for Views
/**
 The `UIModel` public protocol represents a data model for views in the user interface.

 This public protocol defines an associated type `DataModelType`, which represents the type of data model that the UI model will use. It also requires a required initializer `init(dataModel:)`, which should be implemented by conforming types to initialize the UI model with the provided `DataModelType`.

 Example Usage:

// Define a data model
struct UserDataModel {
    var username: String
    var age: Int
}

// Conform to the UIModel public protocol using UserDataModel as the associated type
struct UserUIModel: UIModel {
    typealias DataModelType = UserDataModel
    var username: String
    var age: String
    
    init(dataModel: UserDataModel) {
        self.username = dataModel.username
        self.age = "Age: \(dataModel.age)"
    }
    
}
// Creating a UserUIModel instance using a UserDataModel instance
let userData = UserDataModel(username: "JohnDoe", age: 30)
let userUIModel = UserUIModel(dataModel: userData)
In the above example, we define a `UserDataModel` struct to represent the underlying data for a user. Then, we create a `UserUIModel` struct conforming to the `UIModel` public protocol, using `UserDataModel` as the associated type. The `init(dataModel:)` initializer in `UserUIModel` takes a `UserDataModel` instance and initializes the `username` and `age` properties accordingly.

This public protocol allows for a separation of concerns between the underlying data models and the models specifically tailored for UI presentation.
*/
public protocol UIModel {
   /// The type of the underlying data model used by the UI model.
    associatedtype DataModelType

   /**
    Initializes the UI model with the provided data model.

    - Parameter dataModel: The data model instance used to populate the UI model.

    This initializer should be implemented by conforming types to populate the UI model properties based on the given `dataModel`.

    Example Usage:
    ```
    struct UserUIModel: UIModel {
        typealias DataModelType = UserDataModel

        var username: String
        var age: String
        init(dataModel: UserDataModel) {
            self.username = dataModel.username
            self.age = "Age: \(dataModel.age)"
        }
    }
    ```
    In this example, `UserUIModel` is a concrete implementation of the `UIModel` public protocol. The initializer takes a `UserDataModel` instance and sets the `username` and `age` properties accordingly.
   */
   init(dataModel: DataModelType)
}
