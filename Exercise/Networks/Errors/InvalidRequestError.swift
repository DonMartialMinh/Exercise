//
//  InvalidRequestError.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/4/21.
//

import Foundation

struct InvalidRequestError: Decodable {
    let errors: [JsonError]
}

struct JsonError: Codable {
    let code: String
    let parameter: String
    let message: String
}
