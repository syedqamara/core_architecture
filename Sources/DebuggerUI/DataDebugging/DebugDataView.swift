//
//  File.swift
//  
//
//  Created by Apple on 19/08/2023.
//

import Foundation
import Core
import SwiftUI
import Dependencies
import Debugger
import CoreUI



extension KeyValueData: Identifiable {
    public var id: String { key }
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
                        skin: .default
                    )
                    .id("Root")
                }
            }
            .navigationBarBackButtonHidden(false)
        }
    }
}

extension DebugDataView {
    public struct Skin: SkinTuning {
        public static var `default`: DebugDataView.Skin { .init(configID: "DebugDataView.Skin.default.configID") }
        public var configID: String
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


public struct DebugDataViewTT_Previews: PreviewProvider {
    public static var previews: some View {
        NetworkDebugModule(
            input: NetworkDebugModule.preview
        ).view()
            .environmentObject(NetworkDebugConnectionViewModel(debugger: .liveValue))
            
    }
}


