//
//  ReadJsonParsing.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation
@testable import GooglePlayBook

protocol ReadJsonParsing {
    func readJsonObject<T:Decodable>(fileName: String) -> T?
}
extension ReadJsonParsing {
    func readJsonObject<T:Decodable>(fileName: String) -> T? {
        guard let path  = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            if let model = try? decoder.decode(T.self, from: jsonData) {
                return model
            }
        }catch {
            print("Json read error",error.localizedDescription)
        }
        return nil
    }
}
