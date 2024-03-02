//
//  System Images.swift
//  AppStoreManager
//
//  Created by Apple on 03/03/2024.
//

import Foundation
import SwiftUI

public enum FolderImage: String {
    case folder = "folder"
    case folderFill = "folder.fill"
    case folderBadgePlus = "folder.badge.plus"
    case folderFillBadgePlus = "folder.fill.badge.plus"
    case folderBadgeMinus = "folder.badge.minus"
    case folderFillBadgeMinus = "folder.fill.badge.minus"
    case folderCircle = "folder.circle"
    case folderCircleFill = "folder.circle.fill"
    case folderSquare = "folder.square"
    case folderSquareFill = "folder.square.fill"
    case folderFillCircle = "folder.fill.circle"
    case folderFillCircleFill = "folder.fill.circle.fill"
    case folderFillSquare = "folder.fill.square"
    case folderFillSquareFill = "folder.fill.square.fill"
}

public extension Image {
    init(systemName: FolderImage) {
        self.init(systemName: systemName.rawValue)
    }
}
