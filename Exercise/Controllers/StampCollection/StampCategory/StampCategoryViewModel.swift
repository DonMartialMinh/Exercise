//
//  CategoryViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/27/21.
//

import Foundation

protocol StampCategoryViewModelEvents: class {
    func didUpdateCategory(_ stampCategoryViewModel: StampCategoryViewModel, _ categories: [Category])
    func didFailWithError(error: ​ResponseError​)
}

struct StampCategoryViewModel {
    weak var delegate: StampCategoryViewModelEvents?

    // MARK: - Method
    func fetchCategories() {
        APIManager.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                delegate?.didUpdateCategory(self, categories!.data)
            case .failure(let error):
                delegate?.didFailWithError(error: error)
            }
        }
    }
}
