//
//  VariationOptions.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/15/21.
//

import Foundation
import RealmSwift

class VariationOptions: Object {
    let colorCode = List<String>()
    let photoCount = List<Int>()
    let postcardTypeId = List<Int>()
    let greetingType = List<Int>()
}
