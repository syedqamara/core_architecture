//
//  File.swift
//  
//
//  Created by Apple on 10/12/2023.
//

import Foundation
import Core

@propertyWrapper
struct NetworkCache {
    private let url: URL
    private let fileService = FileService()
    public init(url: URL) {
        self.url = url
    }
    var wrappedValue: Data? {
        get {
            @CachedPermanent<String>(key: url.absoluteString) var fileNameCache
            if let fileNameCache {
                @Cached<Data>(key: fileNameCache) var fileInCache
                if let fileInCache {
                    return fileInCache
                }
                return try? fileService.load(fileName: fileNameCache)
            }
            return nil
        }
        set {
            @CachedPermanent<String>(key: url.absoluteString) var fileNameCache: String?
            let newFileName = UUID().uuidString + ".xpsc"
            _fileNameCache.wrappedValue = newFileName
            fileService.save(fileName: newFileName, data: newValue)
        }
    }
}
