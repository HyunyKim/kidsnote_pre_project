//
//  ImageDownloader.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation


final class ImageDownloader: ImageDownloadable {
    static let shared = ImageDownloader()
    
    private init() { }
    
    @discardableResult
    func downloadImage(urlString: String, etag: String? = nil, completion: @escaping (Swift.Result<Data?, Error>) -> Void) -> Cancellable? {
        guard let imageURL = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidRequest as Error))
            return nil
        }
        var request = URLRequest(url: imageURL,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        if let tag = etag {
//TODO: - Etag...필드가 없음..
            request.addValue(tag, forHTTPHeaderField: "If-None-Match")
        }
        let cancellable = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.unKownError(description: "Invalid HTTP Response")))
                return
            }
            if let tag = httpResponse.allHeaderFields["Etag"] as? String {
                print("Etg - ",tag)
            }
                
            switch httpResponse.statusCode {
                case 200..<300:
                    completion(.success(data))
                case 304:
                    completion(.success(nil))
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
                completion(.failure(NetworkError.clientError(statusCode: httpResponse.statusCode, description: message)))
            case 500..<600:
                var message: String = "Server Error"
                if httpResponse.statusCode == 500 {
                    message = "Internal Server Error - 서버에서 에러가 발생했습니다"
                } else if httpResponse.statusCode == 501 {
                    message = "Not Implementd - 서버에서 에러가 발생했습니다"
                } else if httpResponse.statusCode == 402 {
                    message = "Bad Gateway - 서버에서 에러가 발생했습니다"
                }
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode, description: message)))
            default:
                completion(.failure(NetworkError.unKownError(description: "Not Defined Error \(httpResponse.statusCode)")))
            }
        }
        cancellable.resume()
        return cancellable
    }
}
