//
//  DataModel.swift
//  
//
//  Created by Apple on 25/07/2023.
//

import Foundation

// MARK: - Base Data Model Protocol
public protocol DataModelProtocol {}
// MARK: - Data Model
public protocol DataModel: DataModelProtocol, Codable {}
