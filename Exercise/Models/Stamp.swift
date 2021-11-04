//
//  Stamp.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/4/21.
//

import Foundation
import RealmSwift

class Stamp: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var thumbnailImageUrl: String = ""
    @objc dynamic var date: Date = Date()
}
