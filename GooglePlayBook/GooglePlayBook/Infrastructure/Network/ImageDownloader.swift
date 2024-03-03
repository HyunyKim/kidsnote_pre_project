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
            
            switch httpResponse.statusCode {
                case 200..<300:
                    completion(.success(data))
                case 304:
                    completion(.success(nil))
            case 400..<500:
                completion(.failure(NetworkError.clientError(statusCode: httpResponse.statusCode, description: "Client Error") as Error))
            case 500..<600:
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode, description: "Server Error") as Error))
            default:
                completion(.failure(NetworkError.unKownError(description: "Not Defined Error \(httpResponse.statusCode)")))
            }
        }
        cancellable.resume()
        return cancellable
    }
}
