//
//  File.swift
//  
//
//  Created by Apple on 25/08/2023.
//

import Foundation
import Core

extension Hosting {
    var url: URL? {
        URL(string: scheme + "://" + host + "\(port == 0 ? "" : ":\(port)")" + "/\(path)")
    }
}
public extension Pointable {
    
}
extension URLSessionDataTask: SessionTask { }
extension URLSession: SessionManager {
    public func task(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionTask? {
        return self.dataTask(with: request, completionHandler: completionHandler)
    }
}
