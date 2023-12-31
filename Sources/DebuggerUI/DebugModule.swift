//
//  DebugModule.swift
//  
//
//  Created by Apple on 20/08/2023.
//

import Foundation
import core_architecture
import Debugger
import SwiftUI
import Dependencies





public struct NetworkDebugModule: ViewModuling {
    public static var preview: ModuleInput { .init(configID: "123", debugID: "123", debugData: .data(RootObject.example(), RootObject.self)) }
    public typealias ViewType = NetworkDebugView
    public typealias ModuleInput = NetworkDebuggerActions
    public let input: ModuleInput
    public init(input: ModuleInput) {
        self.input = input
    }
    public func view() -> NetworkDebugView {
        NetworkDebugView(
            viewModel: NetworkDebugViewModel(
                action: input
            )
        )
    }
}



public struct NetworkDebugView: SwiftUIView {
    public typealias ViewModelType = NetworkDebugViewModel
    @Dependency(\.networkModuleKeyValueTheme) var theme
    @ObservedObject var viewModel: NetworkDebugViewModel
    @EnvironmentObject var networkDebugConnectionVM: NetworkDebugConnectionViewModel
    @Environment(\.presentationMode) var presentationMode
    public init(viewModel: NetworkDebugViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        NavigationUI {
            VStack {
                RoundedBorderView(height: 40) {
                    HStack {
                        HStack {
                            if viewModel.isEditingEnabled {
                                Text("Disable Editing")
                                    .font(theme.headerTitleFont)
                                    .foregroundColor(theme.keyTiteColor)
                            }else {
                                Text("Enable Editing")
                                    .font(theme.headerTitleFont)
                                    .foregroundColor(theme.keyTiteColor)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                viewModel.isEditingEnabled.toggle()
                            }
                        }
                        Spacer()
                        Text("Save")
                            .font(theme.headerTitleFont)
                            .foregroundColor(viewModel.isEditingEnabled ? theme.keyTiteColor : theme.valueTiteColor)
                            .onTapGesture {
                                viewModel.save()
                                presentationMode.wrappedValue.dismiss()
                                
                            }
                        
                    }
                    .padding(.horizontal)
                }
                .frame(height: 40)
                
                switch viewModel.debuggerAction {
                case .request:
                    URLRequestDebugModule(
                        input: .init(
                            request: viewModel.requestBinding(),
                            isEditingEnabled: $viewModel.isEditingEnabled
                        )
                    )
                    .view()
                    .environmentObject(networkDebugConnectionVM)
                    .id(viewModel.debuggerAction.rawValue)
                default:
                    DebugDataView(viewModel: viewModel)
                        .environmentObject(networkDebugConnectionVM)
                        .id(String(describing: viewModel))
                }
                Spacer()
            }
            .padding(.top, 10)
            .background(theme.backgroundColor)
            .navigationBarBackButtonHidden(false)
        }
    }
}
public class NetworkDebugViewModel: ViewModeling {
    public enum NetworkDebugAction: String {
    case request, data, error, response
        public init(networkDebugAction: NetworkDebuggers) {
            switch networkDebugAction {
            case .request(_):
                self = .request
            case .data(_, _):
                self = .data
            case .error(_):
                self = .error
            case .response(_):
                self = .response
            }
        }
    }
    @Dependency(\.networkDebugConnection) private var debugConnection
    private var action: NetworkDebuggerActions
    @Published public var debuggerAction: NetworkDebugAction
    @Published public var keyValues: [KeyValueData]
    @Published public var isExpanded: Bool = true
    @Published public var isEditingEnabled: Bool = false
    init(action: NetworkDebuggerActions) {
        self.action = action
        self.keyValues = []
        debuggerAction = .init(networkDebugAction: action.debugData)
        fatchAndSetupKeyValue()
    }
    public func bindingKeyValues() -> Binding<[KeyValueData]> {
        .init {
            return self.keyValues
        } set: { newKeyValues in
            self.keyValues = newKeyValues
        }

    }
    public func requestBinding() -> Binding<URLRequest> {
        .init {
            return self.request() ?? URLRequest(url: .init(string: "https://www.google.com")!)
        } set: { newRequest in
            self.action.debugData = .request(newRequest)
        }

    }
    private func data() -> DataModel? {
        switch action.debugData {
        case .data(let dataModel, _):
            return dataModel
        default:
            return nil
        }
    }
    private func request() -> URLRequest? {
        switch action.debugData {
        case .request(let request):
            return request
        default:
            return nil
        }
    }
    private func dataType() -> DataModel.Type? {
        switch action.debugData {
        case .data(_ ,let dataModelType):
            return dataModelType
        default:
            return nil
        }
    }
    private func fatchAndSetupKeyValue() {
        guard let keyValues = data()?.data?.dictionary()?.keyValues() else { return }
        self.keyValues = keyValues.debugDataSorting
    }
    func save() {
        let saveDict = self.keyValues.map { $0.dictionary }.merge()
        if let dataModelType = dataType(), let dataModel = saveDict.decode(dataModelType) {
            self.action.debugData = .data(dataModel, dataModelType)
            self.debugConnection.sendReaction(action: action)
        }
        fatchAndSetupKeyValue()
        isEditingEnabled.toggle()
    }
}
import Debugger

public struct DebugDataViewT_Previews: PreviewProvider {
    public static var previews: some View {
        NetworkDebugModule(
            input: NetworkDebugModule.preview
        ).view()
            .environmentObject(NetworkDebugConnectionViewModel(debugger: .liveValue))
            
    }
}
