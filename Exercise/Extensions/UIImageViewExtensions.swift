//
//  UIImageViewExtensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/19/21.
//

import Foundation
import UIKit
import Photos

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
}
