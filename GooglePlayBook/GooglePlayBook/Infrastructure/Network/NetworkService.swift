//
//  NetworkService.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation
import Network

enum NetworkError: Error {
    case invalidRequest
    case clientError(statusCode: Int, description: String)
    case serverError(statusCode: Int, description: String)
    case jsonParsingError(description: String)
    case unKownError(description: String)
    
}

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }

protocol NetworkService {
    typealias CompleteHandler<T:Decodable> = (Swift.Result<T,NetworkError>) -> Void
    func request<T>(endpoint: API, completion: @escaping(CompleteHandler<T>)) -> Cancellable?
}


extension NetworkService {
    func request<T>(endpoint: API, completion: @escaping(CompleteHandler<T>)) -> Cancellable? {
        //TODO: - request에 throw에 대해서 어떻게 해결할텐가
        let cancellable = URLSession.shared.dataTask(with: try! endpoint.request()) { data, response, error in
            if let error = error , let httpResponse =  response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 400..<500:
                    completion(.failure(.clientError(statusCode: httpResponse.statusCode, description: error.localizedDescription)))
                    return
                case 500..<600:
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode, description: error.localizedDescription)))
                    return
                default:
                    completion(.failure(.unKownError( description: error.localizedDescription)))
                    return
                }
            } else {
                do {
                    guard let responseData = data else {
                        completion(.failure(.jsonParsingError(description: "Data is Null")))
                        return
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    let model = try decoder.decode(T.self, from: responseData)
                    completion(.success(model))
                }catch let parsingError {
                    completion(.failure(.jsonParsingError(description: parsingError.localizedDescription)))
                }
            }
        }
        cancellable.resume()
        
        return cancellable
    }
}
