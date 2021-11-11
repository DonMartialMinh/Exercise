//
//  CardListViewModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/11/21.
//

import Foundation

protocol CardListViewModelEvent: class {
    func didUpdateFavoriteDesigns(_ cardListViewModel: CardListViewModel, favoriteDesignArray: [FavoriteDesign])
}

struct CardListViewModel {
    let userDefault = UserDefaults.standard
    weak var delegate: CardListViewModelEvent?

    func loadFavoriteDesigns() {
        if let data = userDefault.data(forKey: Constants.favoriteDesignskey) {
            do {
                let decoder = JSONDecoder()
                let favoriteDesigns = try decoder.decode([FavoriteDesign].self, from: data)
                self.delegate?.didUpdateFavoriteDesigns(self, favoriteDesignArray: favoriteDesigns)
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
}
