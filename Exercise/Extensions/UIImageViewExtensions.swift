//
//  UIImageViewExtensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/19/21.
//

import UIKit
import Photos
import Alamofire

fileprivate let imageCache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.totalCostLimit = 100_000_000
    return cache
}()

extension UIImageView {
    func fetchImage(asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode){
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        //requestOptions.version = .original
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { (image,_) in
            guard let image = image else { return }
            self.image = image
        }
    }

    func loadFromUrl (_ urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: urlString) else { return }
            AF.request(url, method: .get).response { [weak self] responseData in
                guard let self = self else { return }
                if let data = responseData.data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
