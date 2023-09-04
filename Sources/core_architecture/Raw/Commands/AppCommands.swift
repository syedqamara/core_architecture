//
//  File.swift
//  
//
//  Created by Apple on 04/09/2023.
//

import Foundation
import SwiftUI


public struct AppToolbar<M: MenuInput>: ToolbarContent {
    private var menu: M
    public init(menu: M) {
        self.menu = menu
    }
    private var selectionWidth: CGFloat = 300
    private var selectionHeight: CGFloat = 40
    public var body: some ToolbarContent {
        ToolbarItemGroup {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(menu.subMenus, id: \.id) { subMenu in
                        ZStack {
                            RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                                .foregroundColor(.black)
                            HStack {
                                Text(subMenu.name)
                                    .foregroundColor(.white)
                                    .font(.body.bold())
                                if subMenu.isSelected() {
                                    Spacer(minLength: 30)
                                    Text("✓")
                                        .font(.body.bold())
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onTapGesture {
                            subMenu.invoke()
                        }
                        .frame(height: selectionHeight)
                        .keyboardShortcut(KeyEquivalent(subMenu.shortcut.first ?? Character("")), modifiers: .command)
                    }
                }
            }
            .id(menu.name)
        }
    }
}


public struct AppCommands<M: MenuInput>: Commands {
    private var menu: M
    public init(menu: M) {
        self.menu = menu
    }
    func subMenuSelection(submenu: M.SubMenu) -> Binding<Bool> {
        .init {
            submenu.isSelected()
        } set: { newValue in
            submenu.invoke()
        }

    }
    public var body: some Commands {
        CommandMenu(menu.name) {
            ForEach(menu.subMenus, id: \.id) { subMenu in
                Button {
                    subMenu.invoke()
                } label: {
                    Toggle(subMenu.name, isOn: subMenuSelection(submenu: subMenu))
                }
                .keyboardShortcut(KeyEquivalent(subMenu.shortcut.first ?? Character("")), modifiers: .command)
            }
            
        }
        
    }
}
