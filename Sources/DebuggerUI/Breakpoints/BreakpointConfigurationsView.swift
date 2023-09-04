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
                    NetworkConfigView(config: networkConfig)
                }
            }
        }
    }
    func debuggerList() -> some View {
        List(viewModel.debuggers(), id: \.self) { debugger in
            VStack {
                HStack {
                    Text(debugger)
                        .font(.title.bold())
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(viewModel.selectedDebuggerConfigurations(debugger: debugger).count)")
                        .font(.title.bold())
                        .foregroundColor(.gray)
                }
                listView(configurations: viewModel.selectedDebuggerConfigurations(debugger: debugger))
            }
        }
    }
    func configView(id: String, value: String) -> some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                .foregroundColor(.black)
            VStack {
                HStack {
                    Text("Configuration ID")
                        .font(.title3.bold())
                        .foregroundColor(.gray)
                    Spacer()
                    Text(id)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                HStack {
                    Text("Breakpoint")
                        .font(.title3.bold())
                        .foregroundColor(.gray)
                    Spacer()
                    Text(value)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
    func listView(configurations: [Debug]) -> some View {
        ForEach(configurations, id: \.configID) { configuration in
            configView(id: configuration.configID, value: String(describing: configuration.breakpoint))
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
        }
    }
}
