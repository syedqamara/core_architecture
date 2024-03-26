//
//  File.swift
//  
//
//  Created by Apple on 23/03/2024.
//

import Foundation

public protocol Logging {
    associatedtype LoggingAction: LogAction
    associatedtype LogType
    func log(log: LogType)
    func trackLog<D>(type: LogType,_ data: D?, action: LoggingAction)
}
