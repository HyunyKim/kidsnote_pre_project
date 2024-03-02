//
//  ReadJsonParsing.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation
//@testable import GooglePlayBook

protocol ReadJsonParsing {
    func readJsonObject<T:Decodable>(fileName: String) -> T?
    func readJsonNCompletion<T:Decodable>(fileName: String,
                                          completion:@escaping(Swift.Result<T, Error>) -> Void)
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
    
    func readJsonNCompletion<T:Decodable>(fileName: String,
                                          completion:@escaping(Swift.Result<T, Error>) -> Void) {
     
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            let error = NSError()
            completion(.failure(error))
            return
        }
        do {
            let jsonData = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            if let model = try? decoder.decode(T.self, from: jsonData) {
                completion(.success(model))
            } else {
                let error = NSError()
                completion(.failure(error))
            }
            
        } catch {
            completion(.failure(error))
        }
        
    }
}
