//
//  Inject.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T

    init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}
