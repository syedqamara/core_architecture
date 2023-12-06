# UIModel Protocol

The `UIModel` protocol represents a data model for views in the user interface.

## Declaration

```swift
protocol UIModel {
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
     In this example, `UserUIModel` is a concrete implementation of the `UIModel` protocol. The initializer takes a `UserDataModel` instance and sets the `username` and `age` properties accordingly.
    */
    init(dataModel: DataModelType)
}
```
## Overview

The UIModel protocol defines a blueprint for data models that represent the data used by views in the user interface. It introduces an associated type DataModelType, which denotes the type of the underlying data model that the UI model will use to populate its properties. The protocol requires a required initializer init(dataModel:), which conforming types should implement to initialize the UI model with the provided DataModelType.

## Example Usage

To demonstrate the usage of the UIModel protocol, we'll create a sample data model and a UI model:

```
// Define a data model
struct UserDataModel {
    var username: String
    var age: Int
}

// Conform to the UIModel protocol using UserDataModel as the associated type
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
```

In this example, we define a `UserDataModel` struct representing the underlying data for a user. Then, we create a `UserUIModel` struct conforming to the `UIModel` protocol, specifying `UserDataModel` as the associated type `DataModelType`. The `init(dataModel:)` initializer in `UserUIModel` takes a `UserDataModel` instance and initializes the username and age properties accordingly.

By adopting the `UIModel` protocol, we achieve a clear separation of concerns between the underlying data models and the models specifically tailored for UI presentation. This separation promotes a more organized and maintainable architecture for UI components in our applications


## Other Documents

- For detail documentation of [`Module`](/Module.md)
- For detail documentation of [`ViewModule`](/ViewModule.md)
- For detail documentation of [`View`](/View.md)
- For detail documentation of [`ViewModel`](/ViewModel.md)

## Author:
[🔗 Syed Qamar Abbas](https://www.linkedin.com/in/syed-qamar-abbas-2b23b794/)
