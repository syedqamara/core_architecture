//
//  File.swift
//  
//
//  Created by Apple on 22/03/2024.
//

import Foundation
import UIKit
import SwiftUI
public enum AssetType {
    case assetImage(String, bundle: Bundle? = nil), systemImage(String)//, remoteImage(UIImage)
}


extension AssetType {
    /// `imageSwiftUI` is `SwiftUI's` `Image` object
    public var imageSwiftUI: Image {
        switch self {
        case .assetImage(let name, let bundle):
            return Image(name, bundle: bundle)
        case .systemImage(let name):
            return Image(systemName: name)
//        case .remoteImage(let image):
//            return Image(uiImage: image)
        }
    }
    /// `image` is `UIKit's` `UIImage` object
    public var image: UIImage {
        switch self {
        case .assetImage(let name, let bundle):
            return UIImage(named: name, in: bundle, with: nil) ?? UIImage()
        case .systemImage(let name):
            return UIImage(systemName: name) ?? UIImage()
//        case .remoteImage(let image):
//            return Image(uiImage: image)
        }
    }
}

public enum Assets {
    
}
