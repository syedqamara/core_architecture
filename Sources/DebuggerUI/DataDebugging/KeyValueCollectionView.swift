//
//  KeyValueCollectionViewModel.swift
//  
//
//  Created by Apple on 03/03/2024.
//

import Foundation
import Core
import SwiftUI
import Dependencies
import Debugger
import CoreUI

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
    public func getBindings(kv: KeyValueData) -> Binding<[KeyValueData]> {
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

public struct KeyValueCollectionView: SwiftUIView {
    public typealias ViewModelType = KeyValueCollectionViewModel
    public typealias SkinType = Skin
    @ObservedObject var viewModel: KeyValueCollectionViewModel
    @State var skin: SkinType
    public init(viewModel: KeyValueCollectionViewModel, skin: Skin) {
        self.viewModel = viewModel
        _skin = .init(initialValue: skin)
        print("Keyvalue collection is initialised")
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
//                        .skinTune(skin.vStackSkin)
                    }
                    if viewModel.isExpanded.wrappedValue {
                        VStack {
                            ForEach(viewModel.keyValues) { kv in
                                switch kv.value {
                                case .arrayValue(_):
                                    KeyValueCollectionView(viewModel: .init(key: viewModel.key, keyValues: $viewModel.keyValues, isEditingEnabled: viewModel.isEditingEnabled, isExpanded: viewModel.isEditingEnabled), skin: skin)
                                        .id(kv.id)
                                case .keyValue(_):
                                    KeyValueCollectionView(viewModel: .init(key: viewModel.key, keyValues: $viewModel.keyValues, isEditingEnabled: viewModel.isEditingEnabled, isExpanded: viewModel.isEditingEnabled), skin: skin)
                                        .id(kv.id)
                                        
                                default:
                                    KeyValueView(viewModel: viewModel, kv: kv, isEditingEnabled: viewModel.isEditingEnabled.wrappedValue, skin: .init(title: skin.keyValueSkin.titleSkin, subTitle: skin.keyValueSkin.subtitleSkin, roundedRect: skin.keyValueSkin.roundRectSkin))
                                        .id(kv.id)
                                }
                            }
                        }
                    }
                }
//                .skinTune(skin.keySkin)
            }
//            .skinTune(skin.vStackSkin)
//            .skinTune(skin.keyValueContainerSkin)
            
        }
        
    }
}
public extension KeyValueCollectionView {
    public struct Skin: Skinning {
        public static var `default`: KeyValueCollectionView.Skin { .init(headerSkin: .default, keyValueContainerSkin: .default, keySkin: .default, valueSkin: .default, collectionSkin: .default, keyValueSkin: .init(titleSkin: .default, subtitleSkin: .default, roundRectSkin: .default)) }
        
        
        
        public struct KeyValueSkin {
            public var titleSkin: TextualSkin
            public var subtitleSkin: TextualSkin
            public var roundRectSkin: ViewSkin
        }
        
        public var headerSkin: ViewSkin
        public var keyValueContainerSkin: ViewSkin
        public var vStackSkin: VStackSkin = .default
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
