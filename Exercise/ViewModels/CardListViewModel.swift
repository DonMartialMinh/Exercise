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
    func didUpdateTemplates(_ cardListViewModel: CardListViewModel, template: TemplateFromJson)
    func didFailWithError(error: ​ResponseError​)
}

struct CardListViewModel {
    let realm = try! Realm()
    let userDefault = UserDefaults.standard
    weak var delegate: CardListViewModelEvent?

    func loadFavoriteDesigns() {
        if let data = userDefault.data(forKey: Constants.favoriteDesignskey) {
            do {
                let decoder = JSONDecoder()
                let favoriteDesigns = try decoder.decode([FavoriteDesign].self, from: data)
                self.delegate?.didUpdateFavoriteDesigns(self, favoriteDesigns: favoriteDesigns)
            } catch {
                print("Unable to Decode Array of Favorite Design (\(error))")
            }
        } else {
            print("Error loading favorite designs")
        }
    }

    func saveFavoriteDesign(favDesignArray: [FavoriteDesign]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favDesignArray)
            userDefault.set(data, forKey: Constants.favoriteDesignskey)
        } catch {
            print("Unable to Encode Array of Favorite Design \(error)")
        }
    }

    func fetchTemplate(with code: String) {
        APIManager.shared.fetchTemplates(code: code) { result in
            switch result {
            case .success(let template):
                self.delegate?.didUpdateTemplates(self, template: template!.data[0])
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
}
