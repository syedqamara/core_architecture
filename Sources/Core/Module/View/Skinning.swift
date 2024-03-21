//
//  Theme.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import UIKit

public protocol SkinRegistering {
    associatedtype Skins
    func register(skins: Skins)
}

public protocol Skinning {
    static var `default`: Self { get }
}


// SkinTuning protocol define that a skin is configurable for tuning the Skin differently
public protocol SkinTuning: Skinning, Configurable {
    
}


public protocol SizableSkinning: Skinning {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var borderWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var padding: UIEdgeInsets { get }
}
public protocol ColourfulSkinning: Skinning {
    var backgroundColor: UIColor { get }
    var foreGroundColor: UIColor { get }
    var tintColor: UIColor { get }
    var borderColor: UIColor { get }
}


public protocol ViewSkinning: Skinning {
    var color: ColourfulSkinning? { get }
    var size: SizableSkinning? { get }
}

