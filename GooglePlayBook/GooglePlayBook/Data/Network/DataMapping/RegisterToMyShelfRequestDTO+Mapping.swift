//
//  RegisterToMyShelfRequestDTO.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/7/24.
//

import Foundation

struct RegisterToMyShelfRequestDTO: ParameterEncodable {
    var volumeId: String
    init(volumeId: String) {
        self.volumeId = volumeId
    }
}
