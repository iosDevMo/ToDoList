//
//  ItemTableViewController.swift
//  ToDoList
//
//  Created by mohamdan on 17/07/2023.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var category:Category? {
        didSet {
            itemArray = category?.items.sorted(byKeyPath: "name")
        }
    }
    var itemArray:Results<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category?.name
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var alertText = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default){(action) in
            
            let newItem = Item()
            newItem.name = alertText.text!
            //self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            try! self.realm.write{
                //self.realm.add(newItem)
                self.category?.items.append(newItem)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField() {(alertTextField) in
            alertTextField.placeholder = "Add Category"
            alertText = alertTextField
        }
        present(alert, animated: true)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row].name

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        try! realm.write {
            item.checked = !item.checked
        }
        if item.checked {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
        tableView.reloadData()
    }

}
