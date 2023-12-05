//
//  File.swift
//  
//
//  Created by Apple on 05/12/2023.
//

import Foundation
import SwiftUI

struct NavigationUI<Content: View>: View {

    private var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
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
