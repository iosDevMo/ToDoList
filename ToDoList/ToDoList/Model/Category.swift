//
//  Category.swift
//  ToDoList
//
//  Created by mohamdan on 17/07/2023.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name = " "
    
    let items = List<Item>()
}
