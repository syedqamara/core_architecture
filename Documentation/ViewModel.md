# ViewModeling Protocol

The `ViewModeling` protocol represents a view model that conforms to the `ObservableObject` protocol and specifies associated types for data source and UI model. This protocol serves as a foundation for SwiftUI view models, enabling reactive UI updates when the underlying data changes.

## Declaration

```swift
protocol ViewModeling: AnyObject, ObservableObject {
    /// The associated type representing the data source used by the view model.
    associatedtype DataSourceType

    /// The associated type representing the UI model used by the view model.
    associatedtype UIModelType: UIModel
}
```
## Overview

The ViewModeling protocol extends the ObservableObject protocol and introduces two associated types: DataSourceType and UIModelType. The DataSourceType represents the data source used by the view model and should conform to the DataSourcing protocol. The UIModelType represents the UI model used by the view model and should conform to the UIModel protocol. These associated types enable SwiftUI views to seamlessly interact with view models, allowing for reactive UI updates based on changes in the underlying data and providing a structured approach to handling data presentation and manipulation in SwiftUI-based user interfaces.

### Example Usage

To demonstrate the usage of the ViewModeling protocol, let's define a sample data source and UI model:

``` swift

// Define a struct conforming to DataSourcing protocol
struct UserData: DataSourcing {
    // Data source implementation
}
```
```
// Define a struct conforming to UIModel protocol
struct UserUIModel: UIModel {
    // UI model implementation
}
```
Next, we create a view model conforming to the ViewModeling protocol:

``` swift
class UserProfileViewModel: ViewModeling {
    typealias DataSourceType = UserData
    typealias UIModelType = UserUIModel

    // ViewModeling protocol implementation using UserData as data source and UserUIModel as UI model
}
```
In this example, `UserProfileViewModel` is a class conforming to the `ViewModeling` protocol. We specify `UserData` as the associated `DataSourceType` and `UserUIModel` as the associated `UIModelType`. The view model can now use the `UserData` type to fetch and update data for the `SwiftUI` views, while the `UserUIModel` type is used to format and transform the data for display in the user interface.

By adopting the `ViewModeling` protocol, `SwiftUI` view models become observable objects, and specific types for data source and UI model are enforced. This structured approach improves the architecture of SwiftUI-based user interfaces, making them more maintainable and facilitating a clear separation of concerns between data handling and UI presentation.
## Author:
[🔗 Syed Qamar Abbas](https://www.linkedin.com/in/syed-qamar-abbas-2b23b794/)

Documentation/UIModel.md
Documentation/Module.md
Documentation/ViewModule.md
Documentation/View.md
Documentation/ViewModel.md
