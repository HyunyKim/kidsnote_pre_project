//
//  EBookInfoRequestDTO+Mapping.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

struct BookInfoRequestDTO: ParameterEncodable {
    var projection: String?
    
    init(projection: String? = nil) {
        self.projection = projection
    }
}
