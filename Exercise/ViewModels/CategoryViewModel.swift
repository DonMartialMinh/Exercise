//
//  CategoryViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/27/21.
//

import Foundation

protocol CategoryViewModelEvents: class {
    func didUpdateCategory(_ categoryViewModel: CategoryViewModel, _ categories: [Category])
    func didFailWithError(error: Error)
}

struct CategoryViewModel {
    weak var delegate: CategoryViewModelEvents?

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
