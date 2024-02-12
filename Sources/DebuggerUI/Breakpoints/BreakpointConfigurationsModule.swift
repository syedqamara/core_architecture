//
//  BreakpointConfigurationsModule.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import Foundation
import Core
import CoreUI

public struct BreakpointConfigurationsModule: ViewModuling {
    public typealias ViewType = BreakpointConfigurationsView
    public struct ModuleInput: ModulingInput {
        public init() {}
    }
    private let input: ModuleInput
    public init(input: ModuleInput) {
        self.input = input
    }
    public func view() -> BreakpointConfigurationsView {
        @Skin(.breakpoint) var breakPointSkin: BreakpointConfigurationsView.Skin
        return BreakpointConfigurationsView(viewModel: .init(), skin: breakPointSkin)
    }
}

