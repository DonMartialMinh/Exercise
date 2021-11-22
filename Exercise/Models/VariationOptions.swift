//
//  VariationOptions.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/15/21.
//

import Foundation
import RealmSwift

class VariationOptions: Object, Codable {
    var colorCode = List<String>()
    var photoCount = List<Int>()
    var postcardTypeId = List<Int>()
    var greetingType = List<Int>()

    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case photoCount = "photo_count"
        case postcardTypeId = "postcard_type_id"
        case greetingType = "greeting_type"
    }
}
