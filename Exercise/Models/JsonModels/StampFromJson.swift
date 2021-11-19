//
//  StampModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation

struct StampFromJson: Codable {
    let id: Int
    let thumbnailImageUrl: String
    let compositionImageFilename: String

    enum CodingKeys: String, CodingKey {
        case id
        case thumbnailImageUrl = "thumbnail_image_url"
        case compositionImageFilename = "composition_image_filename"
    }
}
