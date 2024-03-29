//
//  BreakpointConfigurationsView.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import SwiftUI
import Core
import CoreUI
import Debugger
import Network
import Dependencies


extension BreakpointConfigurationsView {
    public struct Skin: SkinTuning {
        public var roundRectSkin: ViewSkin
        public init(roundRectSkin: ViewSkin, configID: String) {
            self.roundRectSkin = roundRectSkin
            self.configID = configID
        }
        public static var `default`: Skin {
            .init(
                roundRectSkin: .default,
                configID: "BreakpointConfigurationsView.Skin.default.configID"
            )
        }
        public var configID: String
    }
}


public struct BreakpointConfigurationsView: SwiftUIView {
    public typealias ViewModelType = BreakpointConfigurationsViewModel
    public typealias SkinType = Skin
    @ObservedObject var viewModel: BreakpointConfigurationsViewModel
    @State var showBreakPointSelectionOption: Bool = false
    @State var skin: SkinType
    @State var networkExpandCollapes: [String: Bool] = [:]
    public init(viewModel: BreakpointConfigurationsViewModel, skin: SkinType) {
        self.viewModel = viewModel
        _skin = .init(initialValue: skin)
    }
    public var body: some View {
        networkList()
    }
    func binding(_ id: String) -> Binding<Bool> {
        .init {
            networkExpandCollapes[id] ?? false
        } set: { newValue in
            networkExpandCollapes[id] = newValue
        }
    }
    @ViewBuilder
    func networkConfigView(_ networkConfig: NetworkConfig) -> some View {
        VStack {
            RoundedBackgroundView {
                VStack {
                    NetworkConfigView(config: networkConfig, isExpanded: binding(networkConfig.to.pointing))
                    if binding(networkConfig.to.pointing).wrappedValue {
                        separater()
                        ForEach(viewModel.debuggers(for: networkConfig.to.debugID), id: \.className) { debugger in
                            DebugConfigView(debug: debugger)
                                .onTapGesture {
                                    viewModel.toggleBreakpoint(for: networkConfig.to.debugID, className: debugger.className)
                                    withAnimation {
                                        binding(networkConfig.to.pointing).wrappedValue.toggle()
                                    }
                                }
                        }
                    }
                    RoundedBorderView(skin: skin.roundRectSkin) {
                        Image(systemName: binding(networkConfig.to.pointing).wrappedValue ? "arrow.down.circle.fill" : "arrow.down.circle")
                            .rotationEffect(.degrees(binding(networkConfig.to.pointing).wrappedValue ? 180 : 0))
                            .font(.subheadline.bold())
                            .foregroundColor(skin.roundRectSkin.color?.borderColor.swiftUI)
                            .onTapGesture {
                                withAnimation {
                                    binding(networkConfig.to.pointing).wrappedValue.toggle()
                                }
                            }
                    }
                }
            }
        }
    }
    
    func networkList() -> some View {
        NavigationUI {
            ScrollView {
                ForEach(viewModel.networks(), id: \.to.configID) { networkConfig in
                    networkConfigView(networkConfig)
                        .onTapGesture {
                            withAnimation {
                                binding(networkConfig.to.pointing).wrappedValue.toggle()
                            }
                        }
                }
            }
            .padding(.horizontal)
            .background(Color.black)
        }
        
    }
}

struct DebugConfigView: View {
    var debug: Debug
    @State var showBreakPointSelectionOption: Bool = false
    
    var body: some View {
        VStack {
            TitleSubtitleView(title: debug.className, subtitle: debug.breakpoint.rawValue, subtitleColor: .blue)
        }
    }
}

struct NetworkConfigView: View {
    var config: NetworkConfig
    @Binding var isExpanded: Bool
    var body: some View {
        VStack {
            TitleSubtitleView(title: "Api Name", subtitle: config.name)
            separater()
            if let host = config.host {
                HostingView(host: host)
            }
            TitleSubtitleView(title: "Endpoint", subtitle: config.to.pointing)
            if isExpanded {
                separater()
                TitleSubtitleView(title: "Method", subtitle: config.method.rawValue)
                separater()
                TitleSubtitleView(title: "Content Type", subtitle: config.contentType.rawValue)
                separater()
                TitleSubtitleView(title: "Response Model", subtitle: String(describing: config.responseType))
                separater()
                TitleSubtitleView(title: "Cache Policy", subtitle: config.cachePolicy.rawValue)
                separater()
                TitleSubtitleView(title: "Headers", subtitle: config.headers.prettyPrintJSONString())
            }
        }
    }
}

struct HostingView: View {
    var host: Hosting
    var body: some View {
        VStack {
            TitleSubtitleView(title: "Scheme", subtitle: host.scheme)
            separater()
            TitleSubtitleView(title: "Host", subtitle: host.host)
            separater()
            TitleSubtitleView(title: "Port", subtitle: "\(host.port)")
            separater()
            TitleSubtitleView(title: "Path", subtitle: host.path)
            separater()
        }
    }
}

struct MockBreakpointView: View {
    init() {
        register(preview: .preview)
        register(preview: .preview1)
        register(preview: .preview2)
    }
    func register(preview: NetworkConfig) {
        @Configuration<NetworkConfig>(preview.to.configID) var networkConfigurations: NetworkConfig?
        _networkConfigurations.wrappedValue = preview
    }
    var body: some View {
        BreakpointConfigurationsView(viewModel: .init(), skin: .default)
    }
}

struct BreakpointConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        MockBreakpointView()
    }
}
