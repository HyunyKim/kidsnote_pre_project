//
//  NetworkService.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation
import Network
import LevelOSLog

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
    @discardableResult
    func request<T>(endpoint: API, completion: @escaping(CompleteHandler<T>)) -> Cancellable?
}


struct DefaultNetworkService: NetworkService {
    func request<T>(endpoint: API, completion: @escaping(CompleteHandler<T>)) -> Cancellable? {
        do {
            let request = try endpoint.request()
            Log.network(request.url ?? "Invalid URL")
            let cancellable = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error  {
                    completion(.failure(.unKownError(description: error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unKownError(description: "Invalid HTTP response")))
                    return
                }
                switch httpResponse.statusCode {
                    
                case 200..<300:
                    do {
                        guard let responseData = data else {
                            completion(.failure(.jsonParsingError(description: "Data is Null")))
                            return
                        }
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .millisecondsSince1970
                        let model = try decoder.decode(T.self, from: responseData)
                        completion(.success(model))
                    } catch {
                        completion(.failure(.jsonParsingError(description: error.localizedDescription)))
                    }
                    
                case 400..<500:
                    completion(.failure(.clientError(statusCode: httpResponse.statusCode, description: "Client Error")))
                    return
                case 500..<600:
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode, description: "Server Error")))
                    return
                default:
                    completion(.failure(.unKownError( description: "Not Defined Error \(httpResponse.statusCode)")))
                    return
                }
            }
            cancellable.resume()
            return cancellable
        } catch {
            completion(.failure(.unKownError(description: error.localizedDescription)))
            return nil
        }
    }
}
