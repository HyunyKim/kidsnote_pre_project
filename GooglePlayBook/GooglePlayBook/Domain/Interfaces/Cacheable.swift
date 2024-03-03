//
//  Cacheable.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation

protocol Cacheable {
    associatedtype Content
    
    func content(for key: String) -> Content?
    func add(with key: String, content: Content)
    func remove(with key: String)
    func removeAll()
}
