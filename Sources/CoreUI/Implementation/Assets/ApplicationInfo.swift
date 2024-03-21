//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation

public struct ApplicationInfo {
    public let name: String
    public let version: String
    public let build: String

    public init() {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let appName = infoDictionary["CFBundleName"] as? String,
              let appVersion = infoDictionary["CFBundleShortVersionString"] as? String,
              let appBuild = infoDictionary["CFBundleVersion"] as? String else {
            fatalError("Failed to fetch application info from Info.plist")
        }

        self.name = appName
        self.version = appVersion
        self.build = appBuild
    }
}
