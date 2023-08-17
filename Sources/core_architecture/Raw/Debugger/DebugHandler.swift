//
//  File.swift
//  
//
//  Created by Apple on 18/08/2023.
//

import SwiftUI

class DebugHandler: DataSourcing {
    static let shared = DebugHandler()
    @Published var currentDisplayingDebugConsole: Debugable?
    func debugModule() -> DebugRequestModule? {
        if let currentDisplayingDebugConsole {
            return DebugRequestModule(input: .init(debug: currentDisplayingDebugConsole))
        }
        return nil
    }
    func display(debug: Debugable) -> Bool {
        if currentDisplayingDebugConsole != nil {
            return false
        }
        currentDisplayingDebugConsole = debug
        return true
    }
}

struct DebugUIModel: UIModel {
    typealias DataModelType = any DataModel
    private let dataModel: Dictionary<String, Any>?
    init(dataModel: any DataModel) {
        self.dataModel = dataModel.data?.dictionary()
    }
}

struct DebugRequestModule: ViewModule {
    typealias ViewType = DebugRequestView
    struct ModuleInput {
        var debug: Debugable
    }
    private let input: ModuleInput
    init(input: ModuleInput) {
        self.input = input
    }
    func view() -> DebugRequestView {
        return DebugRequestView(viewModel: DebugRequestViewModel(debug: input.debug))
    }
}

struct DebugRequestView: ViewProtocol {
    typealias ViewModelType = DebugRequestViewModel
    @ObservedObject var viewModel: ViewModelType
    
    init(viewModel: DebugRequestViewModel) {
        self.viewModel = viewModel
    }
}

class DebugRequestViewModel: ViewModeling, ObservableObject {
    typealias DataSourceType = DebugHandler
    typealias UIModelType = DebugUIModel
    private let debug: Debugable
    init(debug: Debugable) {
        self.debug = debug
    }
}
