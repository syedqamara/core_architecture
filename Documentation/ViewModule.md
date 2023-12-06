# ViewModule Protocol

The `Moduling` protocol represents a modular component that can be instantiated with a specific input, denoted by the associated type `ModuleInput`. This protocol is designed to facilitate the creation of modular components that can encapsulate functionality and be configured with input data as needed.

## Declaration
# ViewModule Protocol

The `ViewModule` protocol represents a view module that conforms to the `Moduling` protocol and specifies an associated type for the view it manages, denoted by `ViewType`. This protocol is designed to encapsulate the logic and configuration of a specific SwiftUI view, allowing for modular and reusable view components.

## Declaration

```swift
protocol ViewModule: Moduling {
    /// The associated type representing the SwiftUI view managed by the view module.
    associatedtype ViewType: ViewProtocol

    /// Returns the configured SwiftUI view managed by the view module.
    ///
    /// - Returns: An instance of the SwiftUI view conforming to `ViewType`.
    ///
    /// Conforming types should implement this method to return an instance of the SwiftUI view, properly configured with its respective view model and any other required dependencies.
    func view() -> ViewType
}
```

## Overview

The ViewModule protocol extends the Moduling protocol, introducing an associated type `ViewType`, which represents the SwiftUI view managed by the view module. The protocol requires a method view() to be implemented by conforming types, which should return an instance of the SwiftUI view, properly configured with its respective view model and any other required dependencies.

Example Usage

``` swift
struct UserProfileView: ViewProtocol {
    // ViewProtocol implementation
}
```
Next, we create a view module conforming to the ViewModule protocol:
``` swift

struct UserProfileModule: ViewModule {
    typealias ViewType = UserProfileView
    typealias ModuleInput = UserProfileInput

    init(input: UserProfileInput) {
        // Initialize the module and configure it with the provided input
    }
    func view() -> UserProfileView {
        // Configure and return an instance of UserProfileView
        let viewModel = UserProfileViewModel() // Assuming UserProfileViewModel is a view model conforming to ViewModeling protocol
        return UserProfileView(viewModel: viewModel)
    }
}

```

To demonstrate the usage of the `ViewModule` protocol, we'll create a sample SwiftUI view conforming to the `ViewProtocol`:

In this example, `UserProfileModule` is a struct conforming to the ViewModule protocol, 
 1. Specifying `UserProfileInput` as the associated ModuleInput type. The `init(input:)` initializer allows the module to be initialized and configured with the provided `UserProfileInput`. The module can then use the input data to set up specific functionality related to the user profile. 
 2. Specifying UserProfileView as the associated ViewType. The view() method is implemented to configure and return an instance of UserProfileView, ensuring that it is properly initialized with its corresponding view model (assuming UserProfileViewModel is a view model conforming to ViewModeling protocol) and any other necessary dependencies.

By adopting the ViewModule protocol, we create modular and reusable SwiftUI view components. The view module encapsulates the logic and configuration of the SwiftUI view, promoting a separation of concerns and facilitating the creation of scalable and maintainable SwiftUI-based user interfaces.


## Other Documents

- For detail documentation of [`UIModel`](Documentation/UIModel.md)
- For detail documentation of [`Module`](Documentation/Module.md)
- For detail documentation of [`View`](Documentation/View.md)
- For detail documentation of [`ViewModel`](Documentation/ViewModel.md)

## Author:
[🔗 Syed Qamar Abbas](https://www.linkedin.com/in/syed-qamar-abbas-2b23b794/)
