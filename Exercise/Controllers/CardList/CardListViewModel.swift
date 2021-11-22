//
//  CardListViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/11/21.
//

import Foundation
import RealmSwift

protocol CardListViewModelEvent: class {
    func didUpdateFavoriteDesigns(_ cardListViewModel: CardListViewModel, favoriteDesigns: [FavoriteDesign])
    func didFailWithError(error: Error)
}

struct CardListViewModel {
    let realm = RealmCRUD.shared
    let userDefault = UserDefaults.standard
    weak var delegate: CardListViewModelEvent?

    func loadFavoriteDesigns() {
        if let data = userDefault.data(forKey: Constants.favoriteDesignskey) {
            do {
                let decoder = JSONDecoder()
                let favoriteDesigns = try decoder.decode([FavoriteDesign].self, from: data)
                self.delegate?.didUpdateFavoriteDesigns(self, favoriteDesigns: favoriteDesigns)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        } else {
            print("Error loading favorite designs from UserDefault")
        }
    }

    func saveFavoriteDesign(favDesignArray: [FavoriteDesign]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favDesignArray)
            userDefault.set(data, forKey: Constants.favoriteDesignskey)
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }

    func fetchTemplate(with code: String, completion: @escaping (_ result: Result<Template?, Error>)->()) {
        APIManager.shared.fetchTemplates(code: code) { result in
            switch result {
            case .success(let data):
                guard let templates = data?.data.first else { return }
                realm.save(item: templates)
                completion(.success(templates))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
