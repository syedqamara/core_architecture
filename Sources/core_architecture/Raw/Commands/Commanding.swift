//
//  File.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation

public enum MenuType {
case topMenu, sideMenu
}

public protocol SubMenuInput: Identifiable {
    var name: String { get set}
    var shortcut: String { get set}
    var invoke: () -> () { get set}
    var isSelected: () -> (Bool) { get set}
}
public protocol MenuInput {
    associatedtype SubMenu: SubMenuInput
    var name: String { get set}
    var type: MenuType { get set}
    var subMenus: [SubMenu] { get set}
}
public struct GeneralMenuInput<M: SubMenuInput>: MenuInput {
    public typealias SubMenu = M
    public var name: String
    public var type: MenuType
    public var subMenus: [M]
    public init(name: String, type: MenuType, subMenus: [M]) {
        self.name = name
        self.type = type
        self.subMenus = subMenus
    }
}
public struct GeneralSubMenu<T: CustomStringConvertible>: SubMenuInput {
    public var id: String
    public var name: String
    public var shortcut: String
    public var invoke: () -> ()
    public var isSelected: () -> (Bool)
    public init(id: String, name: T, shortcut: String, invoke: @escaping () -> Void, isSelected: @escaping () -> Bool) {
        self.id = id
        self.name = name.description
        self.shortcut = shortcut
        self.invoke = invoke
        self.isSelected = isSelected
    }
}
