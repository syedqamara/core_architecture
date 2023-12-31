//
//  File.swift
//  
//
//  Created by Apple on 09/12/2023.
//

import Foundation
import UIKit
import core_architecture

struct PNGImageCoding: EncodingProtocol, DecodingProtocol {
    func encode(data: DataModelProtocol) throws -> Data {
        // Your PNG image encoding logic here
        // For demonstration purposes, let's encode an empty image
        guard let image = data as? UIImage else {
            throw EncodingError.invalidValue("Failed to load empty image", EncodingError.Context(codingPath: [], debugDescription: "data must be an instance of UIImage"))
        }
        
        if let encodedData = image.pngData() {
            return encodedData
        } else {
            throw EncodingError.invalidValue("Failed to encode PNG image", EncodingError.Context(codingPath: [], debugDescription: "Failed to encode PNG image"))
        }
    }
    
    func decode<D>(data: Data, type: D.Type) throws -> D {
        // Your PNG image decoding logic here
        // For demonstration purposes, let's decode an empty image
        guard let decodedImage = UIImage(data: data) as? D else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to decode PNG image"))
        }
        return decodedImage
    }
}
