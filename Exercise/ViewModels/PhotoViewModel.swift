//
//  PhotoViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/28/21.
//

import Foundation
import Photos

protocol PhotoViewModelEvents: class {
    func didUpdatePhoto(_ photoViewModel: PhotoViewModel,_ photos: PHFetchResult<PHAsset>)
}

struct PhotoViewModel {
    weak var delegate: PhotoViewModelEvents?

    // MARK: - Method
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let Photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        delegate?.didUpdatePhoto(self, Photos)
    }
}
