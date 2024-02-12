//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Core

public struct GetNetworkRequestEncoder: NetworkRequestEncoding {
    public func encode(data: DataModel?) async throws -> String? {
        guard let dictionary = data?.data?.dictionary()?.headersDictionary else { return nil }
        let queryParamString = dictionary.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return queryParamString
    }
}
public struct PostFormNetworkRequestEncoder: NetworkRequestEncoding {
    public func encode(data: DataModel?) async throws -> String? {
        guard let dictionary = data?.data?.dictionary()?.headersDictionary else { return nil }
        let queryParamString = dictionary.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return queryParamString
    }
}
public struct PostJSONNetworkRequestEncoder: NetworkRequestEncoding {
    public func encode(data: DataModel?) async throws -> String? {
        guard let queryParamString = try data?.data?.prettyJSONString() else { return nil }
        return queryParamString
    }
}
