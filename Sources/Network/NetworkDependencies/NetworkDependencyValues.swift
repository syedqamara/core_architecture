//
//  NetworkDependencyValues.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import Dependencies

extension DependencyValues {
    public var defaultNetwork: DefaultNetworkManager {
        get { self[DefaultNetworkManager.self] }
        set { self[DefaultNetworkManager.self] = newValue }
    }
}
