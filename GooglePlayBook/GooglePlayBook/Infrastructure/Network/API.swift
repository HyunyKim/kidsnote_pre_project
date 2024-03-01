//
//  API.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation
import Network
import LevelOSLog

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
}


protocol API {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    //TODO: - 명칭을 Header라 할것인가 HeaderParamerter로 할것인가.
    var header: [String : String] { get }
    var queryParametersEncodable: ParameterEncodable? { get }
    var query: [String : Any]? { get }
    var bodyParametersEncodable: ParameterEncodable? { get }
    var bodyParameters: [String : Any]? { get }
    var timeOut: TimeInterval { get }
    
    func request() throws -> URLRequest
}

extension API {
    
    var header: [String : String] {
        var header = ["Content-Type" : "application/json"]
        header["Accept"] = "application/json"
        //TODO: - 이고셍서 토큰을 넣는것을 생각해 보자.
        return header
    }

    var timeOut: TimeInterval {
        30.0
    }
    
    func requestURL() throws -> URL {
        guard let apiBaseURL = URL(string: baseURL) else {
            throw NetworkError.invalidRequest
        }
        let fullURL = apiBaseURL.appendingPathComponent(path)
        
        guard var urlComponent = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidRequest
        }
        var urlQueryItems = [URLQueryItem]()
        if let queryParam = try? queryParametersEncodable?.asDictionary() ?? self.query {
            queryParam.forEach({
                urlQueryItems.append(.init(name: $0.key, value:"\($0.value)" ))
            })
        }
        urlComponent.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidRequest
        }
        return url
    }
    
    func request() throws -> URLRequest {
        let url = try self.requestURL()
        var urlRequest = URLRequest(url: url)
        
        Log.info("Basic request header", urlRequest.allHTTPHeaderFields ?? "")
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeOut
        
        if let bodyParam = try? bodyParametersEncodable?.asDictionary() ?? self.bodyParameters , !bodyParam.isEmpty, let data = try? JSONSerialization.data(withJSONObject: bodyParam) {
            urlRequest.httpBody = data
        }
        return urlRequest
    }
}
