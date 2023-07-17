//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by mohamdan on 17/07/2023.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var catArray : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category List"
        catArray = realm.objects(Category.self)
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var alertText = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default){(action) in
            
            let newCategory = Category()
            newCategory.name = alertText.text!
            //self.catArray.append(newCategory)
            self.tableView.reloadData()
            
            try! self.realm.write{
                self.realm.add(newCategory)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(){(alertTextField) in
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
        return catArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = catArray[indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemVC = segue.destination as! ItemTableViewController
        let selectCategory = catArray[tableView.indexPathForSelectedRow!.row]
        itemVC.category = selectCategory
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let category = catArray[indexPath.row]
        try! realm.write {
            realm.delete(category)
        }
        tableView.reloadData()
    }
}
