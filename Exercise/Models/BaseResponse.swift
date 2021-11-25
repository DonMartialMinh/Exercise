//
//  BaseResponseModel.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/1/21.
//

import Foundation

struct BaseResponseModel<T: Codable>: Codable {
    let data: [T]
}
