//
//  NetworkPacket.swift
//  
//
//  Created by Apple on 28/11/2023.
//

import Foundation
import core_architecture

public struct NetworkPacket {
    public let time: Date = Date()
    public let config: NetworkConfig
    public let request: Self.NetworkRequest
    public let response: Self.NetworkResponse
    public init(config: NetworkConfig, request: Self.NetworkRequest, response: Self.NetworkResponse) {
        self.config = config
        self.request = request
        self.response = response
    }
}

extension NetworkPacket {
    public struct NetworkRequest {
        public let requestSent: URLRequest
        public let requestData: DataModel?
        public init(requestSent: URLRequest, requestData: DataModel?) {
            self.requestSent = requestSent
            self.requestData = requestData
        }
    }
    public struct NetworkResponse {
        public let response: URLResponse?
        public let data: Data?
        public let error: Error?
        public init(response: URLResponse?, data: Data?, error: Error?) {
            self.response = response
            self.data = data
            self.error = error
        }
    }
}
