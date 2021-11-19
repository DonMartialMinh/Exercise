//
//  CategoryModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/25/21.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
