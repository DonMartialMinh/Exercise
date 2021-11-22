//
//  RealmCRUD.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/22/21.
//

import Foundation
import RealmSwift

struct RealmCRUD {
    static let shared = RealmCRUD()
    let realm = try! Realm()
    private init() {}
    
    func save(item: Object) {
        do {
            try realm.write({
                realm.add(item)
            })
        } catch {
            print(error)
        }
    }

    func delete(item: Object) {
        do {
            try realm.write({
                realm.delete(item)
            })
        } catch {
            print(error)
        }
    }
}
