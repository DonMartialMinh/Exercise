//
//  StampViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/27/21.
//

import Foundation
import RealmSwift

protocol StampViewModelEvents: class {
    func didUpdateStampFromJson(_ stampViewModel: StampViewModel, _ stamps: [StampFromJson])
    func didUpdateStamp(_ stampViewModel: StampViewModel, _ stamps: Results<Stamp>)
    func didFailWithError(error: ​ResponseError​)
}

struct StampViewModel {
    let realm = try! Realm()
    weak var delegate: StampViewModelEvents?

    // MARK: - Method
    func fetchStamps(with id: Int) {
        if id == 1 {
            let stamps = realm.objects(Stamp.self)
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

    func saveStamp(stamp: Stamp) {
        if !checkDuplicated(stamp: stamp) {
            do {
                try realm.write({
                    realm.add(stamp)
                })
            } catch {
                print("Error saving stamp: \(error)")
            }
        }
    }

    func deleteStamp(stamp: Stamp) {
        do {
            try realm.write({
                realm.delete(stamp)
            })
        } catch {
            print("Error deleting stamp: \(error)")
        }
    }

    func checkDuplicated(stamp: Stamp) -> Bool {
        let stamps = realm.objects(Stamp.self)
        for item in stamps {
            if item.name == stamp.name {
                return true
            }
        }
        return false
    }
}
