//
//  File.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

// MARK: - LocalDataSourcing
/// The `LocalDataSourcing` protocol represents a data source for locally stored data that conforms to the `DataSourcing` protocol.
/// It provides an interface to fetch data from local storage, such as JSON files, and map it to model objects that conform to `LocalJSONMappable`.
// sourcery: AutoMockable
protocol LocalDataSourcing: DataSourcing {
    /// Fetches and returns the locally stored data and maps it to the specified model type asynchronously.
    ///
    /// - Parameter type: The model type to which the data will be mapped.
    /// - Returns: An optional instance of the mapped model or `nil` if the data is not available or cannot be mapped.
    /// - Throws: An error if there was an issue fetching or mapping the data.
    ///
    /// Conforming types should implement this method to fetch data from local storage, typically from JSON files, and then map it to the specified model type using `LocalJSONMappable`.
    ///
    /// Example Usage:
    ///
    ///     // Define a struct conforming to LocalJSONMappable protocol
    ///     struct UserProfile: LocalJSONMappable {
    ///         static var filename: String { return "user_profile" }
    ///         static var fileExtension: String { return "json" }
    ///     }
    ///
    ///     // Conform to the LocalDataSourcing protocol and implement the `get` method
    ///     class UserProfileLocalDataSource: LocalDataSourcing {
    ///         func get<M: LocalJSONMappable>(type: M.Type) async throws -> M? {
    ///             // Fetch data from the JSON file and map it to the model type
    ///             let data = try await asyncRead(filename: M.filename, fileExtension: M.fileExtension, bundle: .main)
    ///             return try? JSONDecoder().decode(M.self, from: data)
    ///         }
    ///     }
    ///
    /// In this example, we define a `UserProfile` struct conforming to `LocalJSONMappable`, which represents the model for user profiles stored in a JSON file. Then, we create a `UserProfileLocalDataSource` class conforming to `LocalDataSourcing`, which implements the `get` method to fetch data from the JSON file and map it to the `UserProfile` model using `JSONDecoder`.
    ///
    /// This protocol allows for the implementation of data sources that fetch and map data from local storage, promoting separation of concerns in the architecture.
    ///
    func get<M: LocalJSONMappable>(type: M.Type) async throws -> M?
}

// MARK: - Local JSON Based Model
/// The `LocalJSONMappable` protocol represents a model type that can be mapped from local JSON data.
/// Models conforming to this protocol can be used with `LocalDataSourcing` to fetch and map data from local storage, typically from JSON files.

protocol LocalJSONMappable: DataModel {
    /// The filename of the JSON file that contains the data for the model.
    static var filename: String { get }
    
    /// The file extension of the JSON file that contains the data for the model.
    static var fileExtension: String { get }
}

// Additional Note:
// The `DataModel` protocol is referenced but not provided in the code. This protocol may define additional requirements for models.
// Please ensure that `LocalJSONMappable` conforms to `DataModel` or replace it with an appropriate protocol as needed in your implementation.

