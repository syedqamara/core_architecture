# Documentation

## 1. Network

### Class Description:
The `Network` class represents a network service responsible for making network requests and decoding the received data into specified data models. It conforms to the `Networking` protocol.

### Properties:
- `singleton`: An instance of `Singleable` representing the app's singleton object.
- `dataDecoder`: An instance of the generic type `D`, which conforms to `DataDecoder` and is used to decode received data.

### Methods:
- `init(_ singleton: Singleable)`: Initializes a new instance of `Network` with the provided `singleton`.
- `run<DM>(requestProvider: R, dataType: DM.Type, completion: @escaping (Result<DM, NetworkError>) -> ()) where DM : DataModel`: Executes a network request using the provided `RequestProvider` and calls the completion handler with the result.
- `api<DM>(requestProvider: R, dataType: DM.Type, completion: @escaping (Result<DM, NetworkError>) -> ()) where DM : Responsable`: A convenience method that executes a network request and handles the response based on the status code.

### Conforming Types:
- `Network` conforms to the `Networking` protocol.

## 2. ApplicationMode

### Structure Description:
The `ApplicationMode` structure represents the app mode for the XcodeGPT application. It conforms to the `AppMode` protocol.

### Properties:
- `base`: An instance of `Servable` representing the base server information for the app mode.

## 4. HttpMethod

### Enumeration Description:
The `HttpMethod` enumeration represents different HTTP methods for network requests.

### Cases:
- `get`: The HTTP GET method.
- `post`: The HTTP POST method.

### Computed Property:
- `rawValue`: Returns the raw string value of the HTTP method.

## 3. DataDecoder

### Protocol Description:
The `DataDecoder` protocol defines the interface for decoding data into a specific type. It provides a method to decode data into a `Decodable` type.

### Methods:
- `init()`: Initializes a new instance of the conforming type.
- `decode<T: Decodable>(type: T.Type, data: Data) throws -> T`: Decodes the given `Data` into a value of the specified type `T`. Throws an error if decoding fails.

### Conforming Types:
- `JsonDataDecoder`: A concrete implementation of `DataDecoder` that uses `JSONDecoder` to decode JSON data.
- `XMLDataDecoder`: A concrete implementation of `DataDecoder` that currently uses `JSONDecoder` to decode XML data. (Note: The implementation for XML decoding should be updated to use an appropriate XML parser.)

## 5. NetworkRequestProvider

### Structure Description:
The `NetworkRequestProvider` structure represents a network request provider that conforms to the `NetworkRequestProviderProtocol`. It is used to create and configure a URLRequest for a network request.

### Generic Types:
- `ENDPOINT`: The type representing the endpoint for the network request, conforming to `Pointable`.

### Properties:
- `appMode`: An instance of `AppMode` representing the app mode.
- `endPoint`: An instance of the generic type `ENDPOINT` representing the endpoint of the network request.
- `method`: An instance of `HttpMethod` representing the HTTP method of the network request.
- `parameters`: An optional `DataModel` representing the parameters of the network request.
- `authenticationType`: An instance of `NetworkAuthentication` representing the authentication type for the network request.

### Methods:
- `init(appMode: AppMode, endPoint: ENDPOINT, method: HttpMethod = .get, parameters: DataModel? = nil, authenticationType: NetworkAuthentication = .none)`: Initializes a new instance of `NetworkRequestProvider` with the provided parameters.
- `request`: A computed property that returns a URLRequest based on the app mode, endpoint, method, parameters, and authentication type.

## Example Usage

```swift
// Create an instance of the app mode
let appMode = ApplicationMode(base: MyServable())

// Create an instance of the network request provider
let requestProvider = NetworkRequestProvider(appMode: appMode, endPoint: MyEndpoint(), method: .get)

// Create an instance of the network service
let network = Network<MyNetworkRequestProvider, JsonDataDecoder>(MySingleton())

// Make a network request and handle the response
network.api(requestProvider: requestProvider, dataType: MyResponsable.self) { result in
    switch result {
    case .success(let response):
        // Handle the successful response
        print(response)
    case .failure(let error):
        // Handle the error
        print(error)
    }
}
```

## Author

Author: Syed Qamar Abbas<BR>
Email: syedqamar.a1@gmail.com<BR>
LinkedIn: [Syed Qamar Abbas](https://www.linkedin.com/in/syed-qamar-abbas-2b23b794/)
Architecture/Core/Core/Network/NetworkingREADME.md
