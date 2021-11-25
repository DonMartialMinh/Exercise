//
//  StampViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/27/21.
//

import Foundation
import RealmSwift

protocol StampViewModelEvents: class {
    func didUpdateStampFromJson(_ stampViewModel: StampViewModel, _ stamps: [Stamp])
    func didUpdateStamp(_ stampViewModel: StampViewModel, _ stamps: Results<Stamp>)
    func didFailWithError(error: ​ResponseError​)
}

struct StampViewModel {
    weak var delegate: StampViewModelEvents?

    // MARK: - Method
    func fetchStamps(with id: Int) {
        if id == 1 {
            guard let stamps = DataProvider().objects(Stamp.self) else { return }
            self.delegate?.didUpdateStamp(self, stamps)
        } else {
            APIManager.shared.fetchStamps(id: id) { result in
                switch result {
                case .success(let data):
                    guard let stamps = data?.data else { return }
                    delegate?.didUpdateStampFromJson(self, stamps)
                case .failure(let error):
                    delegate?.didFailWithError(error: error)
                }
            }
        }
    }
}
