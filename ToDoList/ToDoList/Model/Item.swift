//
//  Item.swift
//  ToDoList
//
//  Created by mohamdan on 17/07/2023.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var name = ""
    @objc dynamic var checked = false
    
    let parent = LinkingObjects(fromType: Category.self, property: "items")
}
