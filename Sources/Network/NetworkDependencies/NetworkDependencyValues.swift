//
//  NetworkDependencyValues.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import Dependencies

extension DependencyValues {
    public var defaultNetwork: NetworkManager<Network> {
        get { self[RestfulApiManager.self] }
        set { self[RestfulApiManager.self] = newValue }
    }
    public var imageDownlaoder: NetworkManager<Network>  {
        get { self[ImageDownloadManager.self] }
        set { self[ImageDownloadManager.self] = newValue }
    }
}
