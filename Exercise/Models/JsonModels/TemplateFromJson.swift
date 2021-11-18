//
//  TemplateFromJson.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/15/21.
//

import Foundation

struct TemplateFromJson: Codable {
    let code: String
    let variationOptions: Options
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case variationOptions = "variation_options"
    }
}

struct Options: Codable {
    let colorCode: [String]
    let photoCount: [Int]
    let postcardTypeId: [Int]
    let greetingType: [Int]
    
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case photoCount = "photo_count"
        case postcardTypeId = "postcard_type_id"
        case greetingType = "greeting_type"
    }
}
