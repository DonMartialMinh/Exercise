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

    func fetchTemplate(with code: String, completion: @escaping (TemplateFromJson?)->()) {
        APIManager.shared.fetchTemplates(code: code) { result in
            switch result {
            case .success(let data):
                guard let templates = data?.data.first else { return }
                saveTemplate(template: templates)
                completion(templates)
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

    func saveTemplate(template: TemplateFromJson) {
        let variationOption = VariationOptions()
        variationOption.colorCode.append(objectsIn: template.variationOptions.colorCode)
        variationOption.photoCount.append(objectsIn: template.variationOptions.photoCount)
        variationOption.greetingType.append(objectsIn: template.variationOptions.greetingType)
        variationOption.postcardTypeId.append(objectsIn: template.variationOptions.postcardTypeId)
        let templateModel = Template()
        templateModel.code = template.code
        templateModel.variationOptions = variationOption
        if !checkDuplicated(template: templateModel) {
            do {
                try realm.write({
                    realm.add(templateModel)
                })
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

    func deleteTemplate(template: Template) {
        do {
            try realm.write({
                realm.delete(template)
            })
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }

    func checkDuplicated(template: Template) -> Bool {
        let templates = realm.objects(Template.self)
        for item in templates {
            if item.code == template.code {
                return true
            }
        }
        return false
    }
}
