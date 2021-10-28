//
//  ResponseError.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation

class ​ResponseError​: Codable, Error {
    // MARK: - Parameters
    var key: String?
    var message: String?
    var errors: [JsonError]
}

struct JsonError: Codable {
    let code: String
    let parameter: String
    let message: String
}
