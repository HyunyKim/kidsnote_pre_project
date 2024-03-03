//
//  URL+Extension.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation

extension URL {
    var lastPathComponentWithQueryID: String {
        if query() != nil , let components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            if let idValue = components.queryItems?.first(where: { $0.name == "id" })?.value {
                return "\(lastPathComponent)_\(idValue)"
            }
        }
        return lastPathComponent
    }
}
