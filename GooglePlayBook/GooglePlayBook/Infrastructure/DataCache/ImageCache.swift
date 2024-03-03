//
//  ImageCache.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import UIKit

final class UIImageMemoryCache: Cacheable {
    
    static let shared: UIImageMemoryCache = UIImageMemoryCache()
    
    private var cache = NSCache<NSString,UIImage>()
    private init() {
        cache.totalCostLimit = 100
    }
    
    func content(for key: String) -> UIImage? {
        guard let image = cache.object(forKey: NSString(string: key)) else {
            return nil
        }
        return image
    }
    
    func add(with key: String, content: UIImage) {
        cache.setObject(content, forKey: NSString(string: key))
    }
    
    func remove(with key: String) {
        cache.removeObject(forKey: NSString(string: key))
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}

final class UIImageDiskCache: Cacheable {
    
    static var sharaed: UIImageDiskCache = UIImageDiskCache()
    
    private let fileManager = FileManager()
    private let cacheURL: URL
    
    private init() { 
        self.cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func filePathURL(with key: String) -> URL {
        cacheURL.appending(component: key, directoryHint: .notDirectory)
    }
    
    func content(for key: String) -> Data? {
        try? Data(contentsOf: filePathURL(with: key))
    }
    
    func add(with key: String, content: Data) {
        if !fileManager.fileExists(atPath: cacheURL.path(percentEncoded: true)) {
            try? fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
        }
        fileManager.createFile(atPath: filePathURL(with: key).path(percentEncoded: true), contents: content)
    }
    
    func remove(with key: String) {
        let path = filePathURL(with: key).path(percentEncoded: true)
        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(atPath: path)
        }
    }
    
    func removeAll() {
        try? fileManager.removeItem(at: cacheURL)
    }
    
    
}
