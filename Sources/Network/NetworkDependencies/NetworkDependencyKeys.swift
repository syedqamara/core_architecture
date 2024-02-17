//
//  NetworkDependencyKeys.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import Dependencies



public enum FirebaseDatabaseManager {}
public enum RestfulApiManager {}
public enum ImageDownloadManager {}

extension RestfulApiManager: TestDependencyKey, DependencyKey {
    public static var liveValue: NetworkManager<Network> {
        .init(
            network: Network(
                session: URLSession.shared,
                encoder: JSONCoding(),
                decoder: JSONCoding()
            )
        )
    }
    public static var testValue: NetworkManager<Network> {
        .init(
            network: Network(
                session: URLSession.shared,
                encoder: JSONCoding(),
                decoder: JSONCoding()
            )
        )
    }
}

private let imageCodingHQ = ImageCoding(imageCompressionQuality: 1.0)
extension ImageDownloadManager: TestDependencyKey, DependencyKey {
    public static var liveValue: NetworkManager<Network> {
        .init(
            network: Network(
                session: URLSession.shared,
                encoder: imageCodingHQ,
                decoder: imageCodingHQ
            )
        )
    }
    public static var testValue: NetworkManager<Network> {
        .init(
            network: Network(
                session: URLSession.shared,
                encoder: imageCodingHQ,
                decoder: imageCodingHQ
            )
        )
    }
}
