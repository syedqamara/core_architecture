//
//  KeyValueView.swift
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

public class KeyValueViewModel: ViewModeling {
    @Published var keyValue: KeyValueData? = nil
    public init(keyValue: KeyValueData? = nil) {
        self.keyValue = keyValue
    }
}

public struct KeyValueView: View {
    @ObservedObject var viewModel: KeyValueCollectionViewModel
    @State var skin: Skin
    var isEditingEnabled: Bool
    var kv: KeyValueData
    @State private var lastValueAsString: String = ""
    @State private var valueAsString: String = "" {
        willSet(newValue) {
            setupJSONValue(valueAsString: newValue)
        }
    }
    fileprivate func setupJSONValue(valueAsString: String) {
        
        let binding = viewModel.getBinding(kv: kv)
        var keyValue = binding.wrappedValue
        guard valueAsString.isNotEmpty else {
            return
        }
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
        binding.wrappedValue = keyValue
    }
    init(viewModel: KeyValueCollectionViewModel, kv: KeyValueData, isEditingEnabled: Bool, skin: Skin) {
        self.viewModel = viewModel
        self.kv = kv
        _skin = .init(initialValue: skin)
        self.isEditingEnabled = isEditingEnabled
        self.valueAsString = kv.value.description
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
        body(
            keyValue: viewModel.getBinding(
                kv: kv
            ).wrappedValue
        )
    }
    @ViewBuilder
    public func body(keyValue: KeyValueData) -> some View {
        HStack(alignment: .center) {
            Text(keyValue.key)
//                .skinTune(skin.title)
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
//                    .skinTune(skin.title)
            }
        }
    }
    struct Skin: Skinning {
        static var `default`: KeyValueView.Skin { .init(title: .default, subTitle: .default, roundedRect: .default) }
        
        var title: TextualSkin = .default
        var subTitle: TextualSkin = .default
        var roundedRect: ViewSkin = .default
    }
}
