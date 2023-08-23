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
        HStack {
            Text(keyValue.key)
                .font(.title.bold())
            Spacer()
            if isEditingEnabled {
                TextField("Enter value for \(keyValue.key)", text: binding())
                    .id(keyValue.id)
                    .multilineTextAlignment(.trailing)
                    .font(.title)
                    .frame(height: 50)
            }else {
                Text(keyValue.value.description)
                    .id(keyValue.id)
                    .font(.title)
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

public struct KeyValueCollectionView: View {
    var key: String
    @ObservedObject var viewModel: KeyValueCollectionViewModel
    @Binding var isExpanded: Bool
    @Binding var isEditingEnabled: Bool
    @State var expandedBindings: [String: Bool] = [:]
    let contentHeight: CGFloat = 35
    init(key: String, keyValues: Binding<[KeyValueData]>, isEditingEnabled: Binding<Bool>, isExpanded: Binding<Bool>) {
        self.key = key
        self.viewModel = .init(keyValues: keyValues)
        _isEditingEnabled = isEditingEnabled
        _isExpanded = isExpanded
    }
    func binding(key: String) -> Binding<Bool> {
        .init {
            expandedBindings[key] ?? false
        } set: { newValue in
            expandedBindings[key] = newValue
        }
    }
    
    public var body: some View {
        VStack {
            VStack {
                VStack {
                    RoundedBorderView(height: contentHeight) {
                        HStack {
                            Text(key)
                                .font(.title.bold())
                                .padding(.horizontal)
                            Spacer()
                            Text(isExpanded ? "🔺" : "🔻")
                                .padding(.horizontal)
                        }
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .frame(height: contentHeight)
                
            }
            if isExpanded {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 5)
                        .background(Color.white)
                        .padding(.horizontal)
                    VStack {
                        ForEach(viewModel.keyValues) { kv in
                            switch kv.value {
                            case .keyValue(_):
                                KeyValueCollectionView(key: kv.key, keyValues: viewModel.getBinding(kv: kv), isEditingEnabled: $isEditingEnabled, isExpanded: binding(key: kv.key))
                                    .id(kv.id)
                                    .padding([.horizontal])
                                    
                            case .arrayValue(_):
                                KeyValueCollectionView(key: kv.key, keyValues: viewModel.getBinding(kv: kv), isEditingEnabled: $isEditingEnabled, isExpanded: binding(key: kv.key))
                                    .id(kv.id)
                                    .padding([.horizontal])
                            default:
                                KeyValueView(keyValue: viewModel.getBinding(kv: kv), isEditingEnabled: $isEditingEnabled)
                                    .frame(height: contentHeight)
                                    .id(kv.id)
                                    .padding([.horizontal])
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}


public struct DebugDataView: ViewProtocol, View {
    public typealias ViewModelType = NetworkDebugViewModel
    @ObservedObject var viewModel: NetworkDebugViewModel
    public init(viewModel: NetworkDebugViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    KeyValueCollectionView(key: "Root", keyValues: viewModel.bindingKeyValues(), isEditingEnabled: $viewModel.isEditingEnabled, isExpanded: $viewModel.isExpanded)
                        .id("Root")
                }
            }
            .navigationBarBackButtonHidden(false)
            .navigationTitle(Text("Debug Data"))
        }
    }
}



struct RoundedBorderView<Content: View>: View {
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
                    .stroke(Color.blue, lineWidth: 2)
                    .background(Color.white)
                    .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
                content
                    .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
            }
            .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
        }
    }
}
