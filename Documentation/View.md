# ViewProtocol Protocol


The `ViewProtocol` defines a generic interface for views that require a view model conforming to the `ViewModeling` protocol. This protocol is intended for use in SwiftUI views to enable seamless integration of view models for data presentation and manipulation.

## Declaration

```swift
protocol ViewProtocol {
    /// The associated type representing the view model conforming to the `ViewModeling` protocol.
    associatedtype ViewModelType: ViewModeling

    /// Initializes the view with the provided view model.
    ///
    /// - Parameter viewModel: The view model instance conforming to `ViewModeling`.
    ///
    /// Conforming types should use this initializer to set up the view and bind its properties to the corresponding properties in the view model.
    init(viewModel: ViewModelType)
}
```

## Overview

The ViewProtocol introduces an associated type ViewModelType, which represents the view model conforming to the ViewModeling protocol. This view model provides the necessary data and behavior for the view, enabling SwiftUI views to seamlessly integrate view models for data presentation and manipulation.

### Example Usage

To demonstrate the usage of the ViewProtocol, let's define a sample view model conforming to the ViewModeling protocol:

``` swift

class UserProfileViewModel: ViewModeling {
    // ViewModeling protocol implementation
}
```
Next, we create a SwiftUI view conforming to the ViewProtocol:

``` swift

struct UserProfileView: ViewProtocol {
    typealias ViewModelType = UserProfileViewModel

    // View implementation using UserProfileViewModel as the view model
    init(viewModel: UserProfileViewModel) {
        // Initialize the view and set up bindings with the view model
    }
}
```
In this example, `UserProfileView` is a struct conforming to the `ViewProtocol`, specifying `UserProfileViewModel` as the associated `ViewModelType`. The `init(viewModel:)` initializer allows the view to initialize itself with the provided view model, enabling the view to reactively update its content based on the changes in the view model.

By adopting the `ViewProtocol`, `SwiftUI` views can seamlessly integrate view models, promoting a clear separation of concerns and enabling reactive user interfaces. This separation allows for a more scalable and maintainable SwiftUI-based user interface architecture.


## Other Documents

- For detail documentation of [`UIModel`](Documentation/UIModel.md)
- For detail documentation of [`Module`](Documentation/Module.md)
- For detail documentation of [`ViewModule`](Documentation/ViewModule.md)
- For detail documentation of [`ViewModel`](Documentation/ViewModel.md)

## Author:
[🔗 Syed Qamar Abbas](https://www.linkedin.com/in/syed-qamar-abbas-2b23b794/)
