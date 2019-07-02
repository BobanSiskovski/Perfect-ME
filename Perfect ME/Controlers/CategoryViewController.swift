//
//  CategoryViewController.swift
//  Perfect ME
//
//  Created by test on 7/1/19.
//  Copyright © 2019 bobi. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    var categories = [Category]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        
        tableView.separatorStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name ?? "No categories added yet"
        
        cell.backgroundColor = UIColor.randomFlat
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PerfectMeViewController
        
        if let  indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    func saveCategories()  {
        do{
            try contex.save()
        }catch{
            print("Error saving categories \(error)")
        }
        
        tableView.reloadData()
        
    }


    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadCategories()  {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
        categories = try contex.fetch(request)
        }catch{
            print("error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
                    do {
                        try self.contex.delete(categories[indexPath.row])
                        self.categories.remove(at: indexPath.row)
                    }catch{
                        print("error deleting category \(error)")
                    }
    }
    
}



