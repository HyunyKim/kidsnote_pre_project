//
//  UIImageView+Extension.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import UIKit
import LevelOSLog

protocol ImageDownloadable {
    func downloadImage(urlString: String, etag: String?, completion: @escaping (Swift.Result<Data?, Error>) -> Void) -> Cancellable?
}

extension UIImageView {
    private struct AssociatedKeys {
        static var downloadCancellable = true
    }
    
    var downloadCancellable: Cancellable? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.downloadCancellable) as? Cancellable)
        }
        set {
            guard let newValue = newValue as Cancellable? else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.downloadCancellable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(urlString: String, downloader: ImageDownloadable = ImageDownloader.shared) {
        self.image = nil
        
        guard let imageURL = URL(string: urlString) else {
            return
        }
        
        let imagekey = imageURL.lastPathComponentWithQueryID
        if let image = UIImageMemoryCache.shared.content(for: imagekey) {
            DispatchQueue.main.async {
                self.image = image
            }
            return
        } else if let imageData = UIImageDiskCache.shared.content(for: imagekey) {
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.image = image
                }
                UIImageMemoryCache.shared.add(with: imagekey, content: image)
            }
        } else {
            let canceallable = downloader.downloadImage(urlString: urlString, etag: nil) { [weak self] result in
                switch result {
                case .success(let imageData):
                    guard let data = imageData, let downImage = UIImage(data: data) else {
                        Log.error("Image download error - Invalid Data")
                        DispatchQueue.main.async {
                            self?.image = UIImage(resource: .emptyBook)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self?.image = downImage
                    }
                    UIImageMemoryCache.shared.add(with: imagekey, content: downImage)
                    UIImageDiskCache.shared.add(with: imagekey, content: data)
                    self?.downloadCancellable = nil
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.image = UIImage(resource: .emptyBook)
                    }
                    Log.error("Image download error", error.localizedDescription)
                }
            }
            downloadCancellable = canceallable
        }
    }
    
    func cancelImageDownload() {
        downloadCancellable?.cancel()
        downloadCancellable = nil
    }
}
