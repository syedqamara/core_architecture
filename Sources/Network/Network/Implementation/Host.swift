//
//  File.swift
//  
//
//  Created by Apple on 24/08/2023.
//

import Foundation

public struct NetworkHost: Hosting {
    public var scheme: String
    public var host: String
    public var port: Int
    public var path: String
    public init(scheme: String, host: String, port: Int, path: String) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.path = path
    }
    public static var localHost: Self {
        NetworkHost(
            scheme: "localhost",
            host: "",
            port: 0,
            path: ""
        )
    }
}

