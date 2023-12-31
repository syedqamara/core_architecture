# Core Architecture

Welcome to the Core Architecture documentation. This document serves as an overview of the core protocols and components used in this architecture. For more detailed information on specific topics, please refer to the linked documentation files below:

## 1. UIModel
The `UIModel` protocol represents a data model for views in the user interface. It defines an associated type `DataModelType` and a required initializer `init(dataModel:)` for populating the UI model based on the provided data model.

[Click here for more detail](Documentation/UIModel.md)

## 2. ViewProtocol
The `ViewProtocol` defines a generic interface for views that require a view model conforming to the `ViewModeling` protocol. It enables seamless integration of view models for data presentation and manipulation in SwiftUI views.

[Click here for more detail](Documentation/View.md)


## 3. ViewModeling
The `ViewModeling` protocol represents a view model conforming to `ObservableObject` and specifying associated types for data source and UI model. It serves as a foundation for SwiftUI view models, enabling reactive UI updates when the underlying data changes.

[Click here for more detail](Documentation/ViewModel.md)

## 4. Modules

### a. Moduling
The `Moduling` protocol represents a modular component that can be instantiated with specific input data, denoted by the associated type `ModuleInput`. This protocol facilitates the creation of modular components encapsulating functionality with configurable input data.

[Click here for more detail](Documentation/Module.md)


### b. ViewModule
The `ViewModule` protocol represents a view module conforming to `Moduling` and specifying an associated type for the SwiftUI view it manages. This allows for modular and reusable view components.

[Click here for more detail](Documentation/ViewModule.md)

For more detailed information on each topic, please click on the links provided. Happy reading!

## Author:
[🔗 Syed Qamar Abbas](https://www.linkedin.com/in/syed-qamar-abbas-2b23b794/)
