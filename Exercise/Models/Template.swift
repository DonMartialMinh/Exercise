//
//  Template.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/15/21.
//

import Foundation
import RealmSwift

class Template: Object, Codable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var code: String = ""
    @objc dynamic var variationOptions: VariationOptions?

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case variationOptions = "variation_options"
    }

    func isVariation() -> Bool? {
        guard let variation = variationOptions else { return nil }
        if !variation.photoCount.isEmpty &&
            !variation.colorCode.isEmpty &&
            !variation.greetingType.isEmpty {
            return false
        }
        return true
    }

    func isPhotoSelect() -> Bool? {
        guard let variation = variationOptions else { return nil }
        if variation.photoCount.isEmpty ||
            variation.photoCount.count == 1 &&
            variation.photoCount.contains(0) {
            return false
        }
        return true
    }
}
