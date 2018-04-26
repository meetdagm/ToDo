//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by Dagmawi Nadew-Assefa on 4/25/18.
//  Copyright © 2018 Sason. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //TODO: Instance Properties
    var categoriesArray = [Category]()
    let cellID = "cellID"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        setupCustomTableView()
        loadCategories()
    }
    
    //MARK: -Set up navigation bar
    
    //    TODO: Override Super Class Definition
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
        addItemButton.tintColor = .black
        self.navigationItem.setRightBarButton(addItemButton, animated: true)
        self.navigationItem.title = "Priority"
    }
    
    //    TODO: Define Function that is called when user taps add category button item
    @objc func addCategory() {
        print("Adding Category")
        var provideCategoryTextField = UITextField()
        let promptCategory = UIAlertController(title: "Name of Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let categoryItem = Category(context: self.context)
            categoryItem.name = provideCategoryTextField.text!
            self.categoriesArray.append(categoryItem)
            self.tableView.reloadData()
            self.saveData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        promptCategory.addAction(cancelAction)
        promptCategory.addAction(alertAction)
        promptCategory.addTextField { (textfield) in
            provideCategoryTextField = textfield
            
        }
        
        present(promptCategory, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    //    TODO: Setup Custom Table
    func setupCustomTableView() {
        tableView.separatorStyle = .none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoTableVC = TodoTableViewController()
        todoTableVC.selectedCategory = categoriesArray[indexPath.row]
        navigationController?.pushViewController(todoTableVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //    MARK: Manipulating Core Data
    
    //    TODO: Save New Information
    func saveData(){
        
        do{
            try context.save()
        }
        catch{
            print("Couldn't Save Item")
        }
        
    }
    
    //    TODO: Retrieve Information
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoriesArray = try context.fetch(request)
        }
        catch{
            print("Error Fetching Request")
        }
        tableView.reloadData()
    }
 

}
