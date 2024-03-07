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
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "올바르지 않은 요청입니다"
        case .clientError(let statusCode, let description):
            return "\(statusCode)  \(description)"
        case .serverError(let statusCode, let description):
            return "\(statusCode)  \(description)"
        case .jsonParsingError(let description):
            return "네트워크 DTO Error \(description)"
        case .unKownError(let description):
            return "알수 없는 에러  \(description)"
        }
    }
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
                        Log.error(String(data: data!, encoding: .utf8) ?? "데이터이상")
                        Log.error(error)
                        completion(.failure(.jsonParsingError(description: error.localizedDescription)))
                    }
                    
                case 400..<500:
                    var message: String = "Client Error"
                    if httpResponse.statusCode == 400 {
                        message = "Bad Request - 잘못된 요청입니다"
                    } else if httpResponse.statusCode == 401 {
                        message = "Unauthorized - 권한이 없습니다"
                    } else if httpResponse.statusCode == 403 {
                        message = "Forbidden - 금지된 접근입니다"
                    } else if httpResponse.statusCode == 404 {
                        message = "NotFound - 찾을 수 없습니다"
                    }
                    completion(.failure(.clientError(statusCode: httpResponse.statusCode, description: message)))
                    return
                case 500..<600:
                    var message: String = "Server Error"
                    if httpResponse.statusCode == 500 {
                        message = "Internal Server Error - 서버에서 에러가 발생했습니다"
                    } else if httpResponse.statusCode == 501 {
                        message = "Not Implementd - 서버에서 에러가 발생했습니다"
                    } else if httpResponse.statusCode == 402 {
                        message = "Bad Gateway - 서버에서 에러가 발생했습니다"
                    }
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode, description: message)))
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
