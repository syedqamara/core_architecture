//
//  BreakpointConfigurationsView.swift
//  
//
//  Created by Apple on 05/09/2023.
//

import SwiftUI
import core_architecture
import Debugger
import Network
import Dependencies

public struct BreakpointConfigurationsView: SwiftUIView {
    public typealias ViewModelType = BreakpointConfigurationsViewModel
    @ObservedObject var viewModel: BreakpointConfigurationsViewModel
    @State var showBreakPointSelectionOption: Bool = false
    @State var networkExpandCollapes: [String: Bool] = [:]
    @Dependency(\.networkModuleKeyValueTheme) var theme
    public init(viewModel: BreakpointConfigurationsViewModel) {
        self.viewModel = viewModel
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
                    RoundedBorderView(height: 30) {
                        Image(systemName: binding(networkConfig.to.pointing).wrappedValue ? "arrow.down.circle.fill" : "arrow.down.circle")
                            .rotationEffect(.degrees(binding(networkConfig.to.pointing).wrappedValue ? 180 : 0))
                            .font(.title2.bold())
                            .foregroundColor(theme.borderColor)
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
        NavigationStack {
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
            .background(.black)
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
            HostingView(host: config.host)
            TitleSubtitleView(title: "Endpoint", subtitle: config.to.pointing)
            if isExpanded {
                separater()
                TitleSubtitleView(title: "Method", subtitle: config.method.rawValue)
                separater()
                TitleSubtitleView(title: "Content Type", subtitle: config.contentType.rawValue)
                separater()
                TitleSubtitleView(title: "Response Model", subtitle: String(describing: config.responseType))
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
        BreakpointConfigurationsView(viewModel: .init())
    }
}

struct BreakpointConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        MockBreakpointView()
    }
}
