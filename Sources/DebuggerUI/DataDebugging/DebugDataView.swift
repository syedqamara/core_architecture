//
//  File.swift
//  
//
//  Created by Apple on 19/08/2023.
//

import Foundation
import Core
import SwiftUI




extension KeyValueData: Identifiable {
    public var id: String { key }
}

public struct KeyValueView: View {
    @Binding var keyValue: KeyValueData
    @State var skin: Skin
    @Binding var isEditingEnabled: Bool
    @State private var lastValueAsString: String = ""
    @State private var valueAsString: String = "" {
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
    init(keyValue: Binding<KeyValueData>, isEditingEnabled: Binding<Bool>, skin: Skin) {
        _skin = .init(initialValue: skin)
        _keyValue = keyValue
        _isEditingEnabled = isEditingEnabled
        self.valueAsString = keyValue.wrappedValue.value.description
    }
    func binding() -> Binding<String> {
        .init {
            return valueAsString
        } set: { newValue in
            if newValue != valueAsString {
                lastValueAsString = newValue
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if newValue == lastValueAsString {
                        valueAsString = newValue
                    }
                }
                
            }
        }

    }
    public var body: some View {
        HStack(alignment: .center) {
            Text(keyValue.key)
                .skinTune(skin.title)
            Spacer()
            if isEditingEnabled {
                RoundedBorderView(skin: skin.roundedRect) {
                    TextField("Enter value for \(keyValue.key)", text: binding())
                        .id(keyValue.id)
                        .skinTune(skin.subTitle)
                        
                }
            }else {
                Text(keyValue.value.description)
                    .id(keyValue.id)
                    .multilineTextAlignment(.center)
                    .skinTune(skin.title)
            }
        }
    }
    private func valueBinding() -> Binding<JSONValue> {
        .init {
            return keyValue.value
        } set: { newValue in
            
        }
    }
    struct Skin: Skinning {
        static var `default`: KeyValueView.Skin { .init(title: .default, subTitle: .default, roundedRect: .default) }
        
        var title: TextualSkin
        var subTitle: TextualSkin
        var roundedRect: ViewSkin
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
    struct KeyValueIndex {
        let index: Int
        let binding: Binding<KeyValueData>
    }
    let key: String
    @Binding var keyValues: [KeyValueData]
    var keyValuesDictionaries: [String: KeyValueIndex] = [:]
    var isEditingEnabled: Binding<Bool>
    var isExpanded: Binding<Bool>
    public init(key: String, keyValues: Binding<[KeyValueData]>, isEditingEnabled: Binding<Bool>, isExpanded: Binding<Bool>) {
        self.key = key
        _keyValues = keyValues
        self.isEditingEnabled = isEditingEnabled
        self.isExpanded = isExpanded
        self.keyValuesDictionaries = keyValues.reduce(.init(), { partialResult, binding in
            var part = partialResult
            part[binding.id] = .init(index: partialResult.count, binding: binding)
            return part
        })
    }
    public func getBinding(kv: KeyValueData) -> Binding<[KeyValueData]> {
        if let binding = keyValuesDictionaries[kv.id] {
            let index = binding.index
            let keyValue = binding.binding.wrappedValue
            return self.binding(kv: keyValue, index: index)
        }
        let index = keyValues.firstIndex { kvd in
           return kv.key == kvd.key
        }
        let int = keyValues.distance(from: keyValues.startIndex, to: index!)
        return binding(kv: kv, index: int)
    }
    public func getBinding(kv: KeyValueData) -> Binding<KeyValueData> {
        if let binding = keyValuesDictionaries[kv.id] {
            return binding.binding
        }
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

public struct KeyValueCollectionView: SwiftUIView {
    public typealias ViewModelType = KeyValueCollectionViewModel
    public typealias SkinType = Skin
    @ObservedObject var viewModel: KeyValueCollectionViewModel
    @State var skin: SkinType
    public init(viewModel: KeyValueCollectionViewModel, skin: Skin) {
        self.viewModel = viewModel
        _skin = .init(initialValue: skin)
    }
    @ViewBuilder
    func expandableHeaderView() -> some View {
        Image(systemName: viewModel.isExpanded.wrappedValue ? "arrow.down.circle.fill" : "arrow.down.circle")
            .rotationEffect(.degrees(viewModel.isExpanded.wrappedValue ? 180 : 0))
            .skinTune(skin.headerSkin)
    }
    public var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: skin.keyValueContainerSkin.size?.cornerRadius ?? 0)
                    .stroke(lineWidth: skin.keyValueContainerSkin.size?.borderWidth ?? 1)
                    .stroke(skin.keyValueContainerSkin.color?.backgroundColor.swiftUI ?? .clear)
                
                VStack {
                    VStack {
                        VStack {
                            HStack {
                                Text(viewModel.key)
                                    .lineLimit(1)
                                    .skinTune(skin.keySkin)
                                Spacer()
                                expandableHeaderView()
                            }
                            if viewModel.isExpanded.wrappedValue {
                                Rectangle()
                                    .skinTune(skin.headerSkin)
                                    .frame(height: 1.5)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                viewModel.isExpanded.wrappedValue.toggle()
                            }
                        }
                        .skinTune(skin.headerSkin)
                    }
                    if viewModel.isExpanded.wrappedValue {
                        ForEach(viewModel.keyValues) { kv in
                            switch kv.value {
                            case .arrayValue(_):
                                KeyValueCollectionView(viewModel: .init(key: viewModel.key, keyValues: $viewModel.keyValues, isEditingEnabled: viewModel.isEditingEnabled, isExpanded: viewModel.isEditingEnabled), skin: skin)
                                    .id(kv.id)
                            case .keyValue(_):
                                KeyValueCollectionView(viewModel: .init(key: viewModel.key, keyValues: $viewModel.keyValues, isEditingEnabled: viewModel.isEditingEnabled, isExpanded: viewModel.isEditingEnabled), skin: skin)
                                    .id(kv.id)
                                    
                            default:
                                KeyValueView(keyValue: viewModel.getBinding(kv: kv), isEditingEnabled: viewModel.isEditingEnabled, skin: .init(title: skin.keyValueSkin.titleSkin, subTitle: skin.keyValueSkin.subtitleSkin, roundedRect: skin.keyValueSkin.roundRectSkin))
                            }
                        }
                    }
                }
                .skinTune(skin.keySkin)
            }
            .skinTune(skin.keyValueContainerSkin)
            
        }
    }
}
extension KeyValueCollectionView {
    public struct Skin: Skinning {
        public static var `default`: KeyValueCollectionView.Skin { .init(headerSkin: .default, keyValueContainerSkin: .default, keySkin: .default, valueSkin: .default, collectionSkin: .default, keyValueSkin: .init(titleSkin: .default, subtitleSkin: .default, roundRectSkin: .default)) }
        
        
        
        public struct KeyValueSkin {
            public var titleSkin: TextualSkin
            public var subtitleSkin: TextualSkin
            public var roundRectSkin: ViewSkin
        }
        
        public var headerSkin: ViewSkin
        public var keyValueContainerSkin: ViewSkin
        public var keySkin: TextualSkin
        public var valueSkin: TextualSkin
        public var collectionSkin: ViewSkin
        public var keyValueSkin: KeyValueSkin
        
        public init(headerSkin: ViewSkin, keyValueContainerSkin: ViewSkin, keySkin: TextualSkin, valueSkin: TextualSkin, collectionSkin: ViewSkin, keyValueSkin: KeyValueSkin) {
            self.headerSkin = headerSkin
            self.keyValueContainerSkin = keyValueContainerSkin
            self.keySkin = keySkin
            self.valueSkin = valueSkin
            self.collectionSkin = collectionSkin
            self.keyValueSkin = keyValueSkin
        }
    }
}


public struct DebugDataModule: ViewModuling {
    public typealias ViewType = DebugDataView
    public struct ModuleInput: ModulingInput {
        let action: NetworkDebuggerActions
    }
    private var input: ModuleInput
    public init(input: ModuleInput) {
        self.input = input
    }
    
    public func view() -> DebugDataView {
        @Skin(.data) var dataSkin: DebugDataView.Skin
        return .init(
            viewModel: .init(action: input.action),
            skin: dataSkin
        )
    }
    
}

public struct DebugDataView: SwiftUIView, View {
    public typealias ViewModelType = NetworkDebugViewModel
    public typealias SkinType = Skin
    @State var skin: SkinType
    @ObservedObject var viewModel: NetworkDebugViewModel
    public init(viewModel: NetworkDebugViewModel, skin: SkinType) {
        _skin = .init(initialValue: skin)
        self.viewModel = viewModel
    }
    public var body: some View {
        NavigationUI {
            VStack {
                ScrollView(.vertical) {
                    KeyValueCollectionView(
                        viewModel: KeyValueCollectionViewModel(
                            key: "Root",
                            keyValues: viewModel.bindingKeyValues(),
                            isEditingEnabled: $viewModel.isEditingEnabled,
                            isExpanded: $viewModel.isExpanded
                        ),
                        skin: .init(headerSkin: .init(configID: ""), keyValueContainerSkin: .init(configID: ""), keySkin: .init(configID: "", font: .title), valueSkin: .init(configID: "", font: .title), collectionSkin: .init(configID: ""), keyValueSkin: .init(titleSkin: .init(configID: "", font: .title), subtitleSkin: .init(configID: "", font: .title), roundRectSkin: .init(configID: "")))
                    )
                    .id("Root")
                        
                }
            }
            .navigationBarBackButtonHidden(false)
        }
    }
}

extension DebugDataView {
    public struct Skin: Skinning {
        public static var `default`: DebugDataView.Skin { .init() }
    }
}

struct RoundedBorderView<Content: View>: View {
    var height: CGFloat
    var content: Content
    
    @State var skin: ViewSkinning
    
    init(skin: ViewSkinning, @ViewBuilder content: () -> Content) {
        self.height = (skin.size?.height ?? 0)
        _skin = .init(initialValue: skin)
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: skin.size?.cornerRadius ?? 10)
                    .stroke(Color(uiColor: skin.color?.borderColor ?? .clear), lineWidth: skin.size?.borderWidth ?? 0)
                    .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
                content
                    .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
            }
            .frame(width: geometry.size.width, height: height == 0 ? geometry.size.height : height)
        }
    }
}
import Debugger
import CoreUI

public struct DebugDataViewTT_Previews: PreviewProvider {
    public static var previews: some View {
        NetworkDebugModule(
            input: NetworkDebugModule.preview
        ).view()
            .environmentObject(NetworkDebugConnectionViewModel(debugger: .liveValue))
            
    }
}


