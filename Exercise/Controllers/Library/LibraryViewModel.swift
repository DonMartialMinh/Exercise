//
//  PhotoViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/28/21.
//

import Foundation
import Photos

protocol LibraryViewModelEvents: class {
    func didUpdatePhoto(_ photoViewModel: LibraryViewModel,_ photos: PHFetchResult<PHAsset>)
}

struct LibraryViewModel {
    weak var delegate: LibraryViewModelEvents?

    // MARK: - Method
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let Photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        delegate?.didUpdatePhoto(self, Photos)
    }
}
