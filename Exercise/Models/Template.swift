//
//  Template.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/15/21.
//

import Foundation
import RealmSwift

class Template: Object {
    @objc dynamic var code: String = ""
    @objc dynamic var variationOptions: VariationOptions?
}
