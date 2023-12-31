//
//  File.swift
//  
//
//  Created by Apple on 05/12/2023.
//

import Foundation
import SwiftUI

public struct NavigationUI<Content: View>: View {

    private var content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
        }
    }
}
