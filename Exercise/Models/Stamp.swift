//
//  Stamp.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/4/21.
//

import Foundation
import RealmSwift

class Stamp: Object, Codable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var thumbnailImageUrl: String = ""
    @objc dynamic var date: Date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case thumbnailImageUrl = "thumbnail_image_url"
        case name = "composition_image_filename"
    }
}
