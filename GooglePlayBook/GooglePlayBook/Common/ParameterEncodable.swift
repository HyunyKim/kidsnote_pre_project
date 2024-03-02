//
//  ParameterEncodable.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation

protocol ParameterEncodable: Encodable { }

extension ParameterEncodable {
    func asDictionary() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any] else {
            throw NSError()
        }
        return dictionary
    }
}
