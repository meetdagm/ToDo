//
//  TodoTableViewController.swift
//  ToDo
//
//  Created by Dagmawi Nadew-Assefa on 4/24/18.
//  Copyright © 2018 Sason. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {
    
    //    MARK: - Set instance Properties
    let cellID = "cellID"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    let customTableView = CustomTableView()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        customTableView.tableView.register(TableViewCell.self, forCellReuseIdentifier: cellID)
        customTableView.tableView.delegate = self
        customTableView.tableView.dataSource = self
        loadItems()
        setupNavigationBar()
    }
    
    //  TODO: Set up Navigation Bar
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemPopUp))
        addItemButton.tintColor = .black
        self.navigationItem.setRightBarButton(addItemButton, animated: true)
    }
    
    override func loadView() {
        self.view = customTableView
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    // TODO: Setup number of cells
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    // TODO: setup Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customTableView.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableViewCell
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //TODO: user Taps cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        customTableView.tableView.reloadData()
        customTableView.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    MARK: - Add Brand New Items
    
    //TODO: Setup Navigation Bar right bar button item
    @objc func addItemPopUp() {
        print("Add Item to list")
        var textfield_local = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = textfield_local.text
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveItem()
            self.customTableView.tableView.reloadData()
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new Todo List Item"
            textfield_local = textfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //    MARK: - Store and Retrieve Items from Plist
    
    //    TODO: Save Item to Plist
    func saveItem() {
        
        do{
           try context.save()
           
        }catch {
            print("Found an error encoding Item array")
        }
    }
    
    //   TODO: Retrieve Item from Plist
    func loadItems() {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = predicate
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error Fetching Request: \(error)")
        }
    }
    
}


extension UITableViewController{
    
    var addButton: UIBarButtonItem {
        get{
            let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
            return button
        }
    }
    
    @objc func setupNavigationBar() {
        self.navigationItem.title = "Action Items"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    open override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
