//
//  CacheManager.swift
//  MetFlix
//
//  Created by Apple on 23/11/2023.
//

import Foundation
// MARK: CacheManagerProtocol Protocol

/// A protocol for cache managers in the MetFlix app.
public protocol CacheManagerProtocol {
    func insert<V>(value: V, for key: String)
    func remove(for key: String)
    func get<V>(valuefor key: String) -> V?
}

class SynchronizedCacheManager: CacheManagerProtocol {
    private let cache = NSCache<NSString, AnyObject>()
    private let cacheAccessQueue = DispatchQueue(label: "com.metflix.cacheAccess", attributes: .concurrent)

    static let shared = SynchronizedCacheManager()

    private init() {
        UserDefaults.standard.dictionaryRepresentation()
        // Set up any additional configurations for the cache if needed
    }

    func insert<V>(value: V, for key: String) {
        cacheAccessQueue.async(flags: .barrier) {
            let boxedValue = Box(value)
            self.cache.setObject(boxedValue, forKey: key as NSString)
        }
    }

    func remove(for key: String) {
        cacheAccessQueue.async(flags: .barrier) {
            self.cache.removeObject(forKey: key as NSString)
        }
    }

    func get<V>(valuefor key: String) -> V? {
        var result: V?

        cacheAccessQueue.sync {
            if let boxedValue = cache.object(forKey: key as NSString) as? Box<V> {
                result = boxedValue.value
            }
        }

        return result
    }
}
// Box class to wrap values for AnyObject storage in NSCache
private class Box<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}
