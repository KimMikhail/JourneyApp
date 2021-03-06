//
//  ListWorker.swift
//  Journey
//
//  Created by  Mikhail on 01.03.2021.
//  Copyright (c) 2021  Mikhail. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

let realm = try! Realm()
class ListWorker {
    
    static func saveRoute(_ route: Route) {
        try! realm.write {
            realm.add(route)
        }
    }
    static func deleteRoute(_ route: Route) {
        try! realm.write {
            realm.delete(route)
        }
    }
    func doSomeWork() {
    }
}
