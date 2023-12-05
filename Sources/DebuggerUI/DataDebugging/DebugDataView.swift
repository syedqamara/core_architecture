//
//  File.swift
//  
//
//  Created by Apple on 19/08/2023.
//

import Foundation
import core_architecture
import SwiftUI




extension KeyValueData: Identifiable {
    public var id: String { key }
}

public struct KeyValueView: View {
    @Dependency(\.networkModuleKeyValueTheme) var theme
    @Binding var keyValue: KeyValueData
    @Binding var isEditingEnabled: Bool
    @State private var valueAsString: String {
        didSet {
            setupJSONValue()
        }
    }
    fileprivate func setupJSONValue() {
        print("Checking for Value: \(valueAsString)")
        switch keyValue.value {
        case .stringValue(_):
            keyValue.value = .stringValue(valueAsString)
            return
        case .intValue(_):
            keyValue.value = .intValue(Int(valueAsString) ?? -1)
            return
        case .boolValue(_):
            keyValue.value = .boolValue(Bool(valueAsString) ?? false)
            return
        case .doubleValue(_):
            keyValue.value = .doubleValue(Double(valueAsString) ?? -1.000001)
            return
        default:
            return
        }
    }
    init(keyValue: Binding<KeyValueData>, isEditingEnabled: Binding<Bool>) {
        _keyValue = keyValue
        _isEditingEnabled = isEditingEnabled
        self.valueAsString = keyValue.wrappedValue.value.description
    }
    func binding() -> Binding<String> {
        .init {
            return valueAsString
        } set: { newValue in
            if newValue != valueAsString {
                valueAsString = newValue
            }
        }

    }
    public var body: some View {
        HStack(alignment: .center) {
            Text(keyValue.key)
                .font(theme.keyTitleFont)
                .foregroundColor(theme.keyTiteColor)
                .padding(.horizontal, theme.keyPadding)
            Spacer()
            if isEditingEnabled {
                RoundedBorderView(height: theme.jsonContentHeight) {
                    TextField("Enter value for \(keyValue.key)", text: binding())
                        .id(keyValue.id)
                        .foregroundColor(theme.keyTiteColor)
                        .padding(.horizontal, theme.valuePadding)
                        .multilineTextAlignment(.trailing)
                        .font(
                            theme.valueTitleFont.editingFont()
                        )
                        
                }
            }else {
                Text(keyValue.value.description)
                    .id(keyValue.id)
                    .font(theme.valueTitleFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(theme.valueTiteColor)
                    .padding(.horizontal, theme.valuePadding)
            }
        }
    }
    private func valueBinding() -> Binding<JSONValue> {
        .init {
            return keyValue.value
        } set: { newValue in
            
        }
    }
}

extension Font {
    func editingFont() -> Font {
        if #available(iOS 15.0, *) {
            return self.monospaced()
        } else {
            return self
        }
    }
}

public class KeyValueCollectionViewModel: ViewModeling {
    @Binding var keyValues: [KeyValueData]
    
    init(keyValues: Binding<[KeyValueData]>) {
        _keyValues = keyValues
    }
    public func getBinding(kv: KeyValueData) -> Binding<[KeyValueData]> {
        let index = keyValues.firstIndex { kvd in
           return kv.key == kvd.key
        }
        let int = keyValues.distance(from: keyValues.startIndex, to: index!)
        return binding(kv: kv, index: int)
    }
    public func getBinding(kv: KeyValueData) -> Binding<KeyValueData> {
        let index = keyValues.firstIndex { kvd in
           return kv.key == kvd.key
        }
        let i = keyValues.distance(from: keyValues.startIndex, to: index!)
        return .init {
            return self.keyValues[i]
        } set: { newKeyValueData in
            var keyValues = self.keyValues
            keyValues[i] = newKeyValueData
            self.keyValues = keyValues
        }
    }
    public func binding(kv: KeyValueData, index: Int) -> Binding<[KeyValueData]> {
        .init {
            switch kv.value {
            case .arrayValue(let array):
                return array
            case .keyValue(let array):
                return array
            default:
                return []
            }
        } set: { newValue in
            switch kv.value {
            case .arrayValue(_):
                self.keyValues[index].value = .arrayValue(newValue)
            case .keyValue(_):
                self.keyValues[index].value = .keyValue(newValue)
            default:
                return
            }
        }
    }
}
import Dependencies
public struct KeyValueCollectionView: View {
    @Dependency(\.networkModuleKeyValueTheme) var theme
    var key: String
    @ObservedObject var viewModel: KeyValueCollectionViewModel
    @Binding var isExpanded: Bool
    @Binding var isEditingEnabled: Bool
    @State var expandedBindings: [String: Bool] = [:]
    init(key: String, keyValues: Binding<[KeyValueData]>, isEditingEnabled: Binding<Bool>, isExpanded: Binding<Bool>) {
        self.key = key
        self.viewModel = .init(keyValues: keyValues)
        _isEditingEnabled = isEditingEnabled
        _isExpanded = isExpanded
    }
    func binding(key: String) -> Binding<Bool> {
        .init {
            expandedBindings[key] ?? true
        } set: { newValue in
            expandedBindings[key] = newValue
        }
    }
    @ViewBuilder
    func expandableHeaderView() -> some View {
        Image(systemName: isExpanded ? "arrow.down.circle.fill" : "arrow.down.circle")
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
            .font(theme.headerTitleFont)
            .foregroundColor(theme.borderColor)
            .padding(.horizontal, theme.headerPadding)
    }
    public var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: theme.radius)
                    .stroke(lineWidth: 1)
                    .stroke(theme.keyTiteColor)
                
                VStack {
                    VStack {
                        VStack {
                            HStack {
                                Text(key)
                                    .foregroundColor(theme.keyTiteColor)
                                    .lineLimit(1)
                                    .font(theme.headerTitleFont)
                                    .padding(theme.headerPadding)
                                Spacer()
                                expandableHeaderView()
                            }
                            if isExpanded {
                                Rectangle()
                                    .foregroundColor(theme.keyTiteColor)
                                    .frame(height: 1.5)
                                    .padding(.horizontal, theme.headerPadding)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                        .frame(height: theme.headerHeight)
                    }
                    if isExpanded {
                        ForEach(viewModel.keyValues) { kv in
                            switch kv.value {
                            case .keyValue(_):
                                KeyValueCollectionView(key: kv.key, keyValues: viewModel.getBinding(kv: kv), isEditingEnabled: $isEditingEnabled, isExpanded: binding(key: kv.key))
                                    .id(kv.id)
                                    .padding(.horizontal, theme.keyPadding)
                                    
                            case .arrayValue(_):
                                KeyValueCollectionView(key: kv.key, keyValues: viewModel.getBinding(kv: kv), isEditingEnabled: $isEditingEnabled, isExpanded: binding(key: kv.key))
                                    .id(kv.id)
                                    .padding(.horizontal, theme.keyPadding)
                            default:
                                KeyValueView(keyValue: viewModel.getBinding(kv: kv), isEditingEnabled: $isEditingEnabled)
                                    .frame(height: theme.jsonContentHeight)
                                    .id(kv.id)
                                    .padding(.horizontal, theme.keyPadding)
                            }
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, theme.keyPadding)
            }
            .padding(.vertical, theme.keyPadding)
            .padding(.horizontal, theme.headerPadding)
            
        }
    }
}


public struct DebugDataView: ViewProtocol, View {
    public typealias ViewModelType = NetworkDebugViewModel
    @Dependency(\.networkModuleKeyValueTheme) var theme
    @ObservedObject var viewModel: NetworkDebugViewModel
    public init(viewModel: NetworkDebugViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        NavigationUI {
            VStack {
                ScrollView(.vertical) {
                    KeyValueCollectionView(key: "Root", keyValues: viewModel.bindingKeyValues(), isEditingEnabled: $viewModel.isEditingEnabled, isExpanded: $viewModel.isExpanded)
                        .id("Root")
                }
            }
            .background(theme.backgroundColor)
            .navigationBarBackButtonHidden(false)
        }
    }
}



struct RoundedBorderView<Content: View>: View {
    @Dependency(\.networkModuleKeyValueTheme) var theme
    var height: CGFloat
    var content: Content
    
    init(height: CGFloat, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.borderColor, lineWidth: 2)
                    .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
                content
                    .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
            }
            .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
        }
    }
}
import Debugger

public struct DebugDataViewTT_Previews: PreviewProvider {
    public static var previews: some View {
        NetworkDebugModule(
            input: NetworkDebugModule.preview
        ).view()
            .environmentObject(NetworkDebugConnectionViewModel(debugger: .liveValue))
            
    }
}


