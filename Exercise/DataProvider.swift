//
//  RealmCRUD.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/22/21.
//

import Realm
import RealmSwift

class DataProvider {
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }

        let realm = try! Realm()
        realm.refresh()

        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }

    func object<T: Object>(_ type: T.Type, key: String) -> T? {
        if !isRealmAccessible() { return nil }

        let realm = try! Realm()
        realm.refresh()

        return realm.object(ofType: type, forPrimaryKey: key)
    }

    func add<T: Object>(_ data: [T]) {
        if !isRealmAccessible() { return }

        let realm = try! Realm()
        realm.refresh()

        if realm.isInWriteTransaction {
            realm.add(data, update: .modified)
        } else {
            try? realm.write {
                realm.add(data, update: .modified)
            }
        }
    }

    func add<T: Object>(_ data: T) {
        add([data])
    }

    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }

        let realm = try! Realm()
        realm.refresh()

        try? realm.write {
            action()
        }
    }

    func delete<T: Object>(_ data: [T]) {
        let realm = try! Realm()
        realm.refresh()
        try? realm.write { realm.delete(data) }
    }

    func delete<T: Object>(_ data: T) {
        delete([data])
    }

    func clearAllData() {
        if !isRealmAccessible() { return }

        let realm = try! Realm()
        realm.refresh()
        try? realm.write { realm.deleteAll() }
    }
}

extension DataProvider {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            print("Realm is not accessible")
            return false
        }
        return true
    }

    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}
