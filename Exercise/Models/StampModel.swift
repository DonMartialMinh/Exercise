//
//  StampModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation

struct StampModel: Codable {
  let data : [Stamp]
}

struct Stamp: Codable {
  let id: Int
  let thumbnailImageUrl: String
  let compositionImageUrl: String
  let compositionImageFilename: String
  let useType: [String]

  enum CodingKeys: String, CodingKey {
    case id
    case thumbnailImageUrl = "thumbnail_image_url"
    case compositionImageUrl = "composition_image_url"
    case compositionImageFilename = "composition_image_filename"
    case useType = "use_type"
  }
}
