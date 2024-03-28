//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
import Core

public struct EmptySkin: SkinTuning {
    static public var `default`: EmptySkin = .init(configID: "EmptySkin.default")
    public var configID: String
    public init(configID: String) {
        self.configID = configID
    }
}
