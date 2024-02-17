//
//  File.swift
//  
//
//  Created by Apple on 09/12/2023.
//

import Foundation
import Core

public struct JSONCoding: EncodingProtocol, DecodingProtocol {
    public init() {}
    public func encode(data: DataModelProtocol) throws -> Data {
        guard let jsonDataModel = data as? DataModel else {
            throw EncodingError.invalidValue(data, .init(codingPath: [], debugDescription: "Data does not conforms to protocol `DataModel`"))
        }
        return try JSONEncoder().encode(jsonDataModel)
    }
    
    public func decode<D>(data: Data, type: D.Type) throws -> D where D: DataModelProtocol {
        // Your JSON decoding logic here
        // For demonstration purposes, let's decode an empty dictionary
        guard let jsonType = type as? (DataModel.Type) else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [], debugDescription: "\(type) doesn't conforms to `DataModel`"))
        }
        let decodedData = try JSONDecoder().decode(jsonType, from: data)
        if let decodedData = decodedData as? D {
            return decodedData
        }
        throw DecodingError.typeMismatch(type, .init(codingPath: [], debugDescription: "\(type) doesn't conforms to `DataModelProtocol`"))
    }
}
