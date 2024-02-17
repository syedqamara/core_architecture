//
//  Previewer.swift
//  NYTimes
//
//  Created by Apple on 12/01/2024.
//

import Foundation
import SwiftUI

// MARK: - Previewer

public struct Previewer<State> {
    public let configurations: [Configuration]
    public let configure: (State) -> AnyView

    public init<V: View>(
        configurations: [Configuration],
        configure: @escaping (State) -> V
    ) {
        self.configurations = configurations
        self.configure = { AnyView(configure($0)) }
    }

    public init<V: View>(
        states: [State],
        configure: @escaping (State) -> V
    ) where State: PreviewState {
        self.init(states: states, name: \.name, configure: configure)
    }

    public init<V: View>(
        states: [State],
        name namePath: KeyPath<State, String>,
        configure: @escaping (State) -> V
    ) {
        self.configurations = states.map { Configuration(name: $0[keyPath: namePath], state: $0) }
        self.configure = { AnyView(configure($0)) }
    }

    public var previews: some View {
        ForEach(configurations, id: \.name) { configuration in
            configure(configuration.state)
                .previewDisplayName("\(configuration.name)")
        }
    }
}

// MARK: - PreviewSnapshots.Configuration

public extension Previewer {
    struct Configuration {
        public let name: String
        public let state: State
        
        public init(name: String, state: State) {
            self.name = name
            self.state = state
        }
    }
}

// MARK: - NamedPreviewState

public protocol PreviewState {
    var name: String { get }
}
