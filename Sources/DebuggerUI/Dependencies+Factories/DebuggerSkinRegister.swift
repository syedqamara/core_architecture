//
//  File.swift
//  
//
//  Created by Apple on 10/02/2024.
//

import Foundation
import Core
import CoreUI

public class DebuggerSkinRegister: SkinRegistering {
    public typealias Skins = DebugSkins
    public enum DebugSkins {
    case networkDebug(NetworkDebugView.Skin), request(URLRequestDebugView.Skin), data(DebugDataView.Skin), kv(KeyValueCollectionView.Skin), breakpoint(BreakpointConfigurationsView.Skin)
    }
    public func register(skins: DebugSkins) {
        switch skins {
        case .networkDebug(let newSkin):
            @Skin(skins) var skin: NetworkDebugView.Skin
            _skin.wrappedValue = newSkin
        case .request(let newSkin):
            @Skin(skins) var skin: URLRequestDebugView.Skin
            _skin.wrappedValue = newSkin
        case .data(let newSkin):
            @Skin(skins) var skin: DebugDataView.Skin
            _skin.wrappedValue = newSkin
        case .kv(let newSkin):
            @Skin(skins) var skin: KeyValueCollectionView.Skin
            _skin.wrappedValue = newSkin
        case .breakpoint(let newSkin):
            @Skin(skins) var skin: BreakpointConfigurationsView.Skin
            _skin.wrappedValue = newSkin
        }
    }
    public func register(skins: [DebugSkins]) {
        skins.forEach { register(skins: $0) }
    }
}

public enum DebugSkins {
    case networkDebug, request, data, kv, breakpoint
}
extension DebugSkins {
    public var rawValue: String {
        switch self {
        case .request:
            return "request_skin_id"
        case .networkDebug:
            return "network_debug_skin_id"
        case .data:
            return "data_skin_id"
        case .kv:
            return "let_skin_id"
        case .breakpoint:
            return "breakpoint_skin_id"
        }
    }
}
extension DebuggerSkinRegister.DebugSkins {
    public var rawValue: String {
        switch self {
        case .networkDebug(_):
            return "network_debug_skin_id"
        case .data(_):
            return "data_skin_id"
        case .kv(_):
            return "let_skin_id"
        case .breakpoint(_):
            return "breakpoint_skin_id"
        case .request(_):
            return "request_skin_id"
        }
    }
}
extension Skin {
    fileprivate init(_ key: DebuggerSkinRegister.DebugSkins) {
        self.init(key.rawValue)
    }
}

extension Skin {
    public init(_ key: DebugSkins) {
        self.init(key.rawValue)
    }
}
