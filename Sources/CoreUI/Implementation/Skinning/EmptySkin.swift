//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
import Core

struct EmptySkin: SkinTuning {
    static var `default`: EmptySkin = .init(configID: "EmptySkin.default")
    var configID: String
}
