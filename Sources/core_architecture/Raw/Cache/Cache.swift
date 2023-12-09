//
//  Cache.swift
//  MetFlix
//
//  Created by Apple on 23/11/2023.
//

import Foundation


@propertyWrapper
public struct Cached<V> {
    private let key: String
    private let cacheManager: SynchronizedCacheManager = SynchronizedCacheManager.shared

    public var wrappedValue: V? {
        get {
            return cacheManager.get(valuefor: key)
        }
        set {
            if let newValue = newValue {
                cacheManager.insert(value: newValue, for: key)
            } else {
                cacheManager.remove(for: key)
            }
        }
    }

    public init(key: String) {
        self.key = key
    }
}

@propertyWrapper
public struct CachedPermanent<V> {
    private let key: String
    public var wrappedValue: V? {
        get {
            return UserDefaults.standard.value(forKey: key) as? V
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    public init(key: String) {
        self.key = key
    }
}
