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

public struct BreakpointConfigurationsView: SwiftUIView {
    public typealias ViewModelType = BreakpointConfigurationsViewModel
    @ObservedObject var viewModel: BreakpointConfigurationsViewModel
    @State var showBreakPointSelectionOption: Bool = false
    public init(viewModel: BreakpointConfigurationsViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        networkList()
    }
    func networkList() -> some View {
        List(viewModel.networks(), id: \.to.configID) { networkConfig in
            VStack {
                RoundedBackgroundView {
                    VStack {
                        NetworkConfigView(config: networkConfig)
                        separater()
                        ForEach(viewModel.debuggers(for: networkConfig.to.debugID), id: \.className) { debugger in
                            DebugConfigView(debug: debugger)
                        }
                    }
                }
            }
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
    var body: some View {
        VStack {
            HostingView(host: config.host)
            TitleSubtitleView(title: "Endpoint", subtitle: config.to.pointing)
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
