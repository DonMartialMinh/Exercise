//
//  StampViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/27/21.
//

import Foundation

protocol StampViewModelEvents: class {
    func didUpdateStamp(_ stampViewModel: StampViewModel, _ stamps: [Stamp])
    func didFailWithError(error: ​ResponseError​)
}

struct StampViewModel {
    weak var delegate: StampViewModelEvents?

    // MARK: - Method
    func fetchStamps(with id: Int) {
        APIManager.shared.fetchStamps(id: id) { result in
            switch result {
            case .success(let stamps):
                delegate?.didUpdateStamp(self, stamps!.data)
            case .failure(let error):
                delegate?.didFailWithError(error: error)
            }
        }
    }
}
