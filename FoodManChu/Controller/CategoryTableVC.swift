//
//  CategoryTableVC.swift
//  FoodManChu
//
//  Created by Jadson on 11/08/22.
//

import UIKit
import CoreData

protocol SelectCategoryDelegate {
    func didSelect(category: Category)
}


class CategoryTableVC: UITableViewController  {
    
    var categories: NSFetchedResultsController <Category>?
    var category: Category?
    var delegate: SelectCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        getCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = categories?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath)
        guard let category = categories?.object(at: indexPath) else { return UITableViewCell () }

        cell.textLabel?.text = category.categoryName

        if category == self.category {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let categorySelected = categories?.fetchedObjects, categorySelected.count > 0 {
            let itemCategory = categorySelected[indexPath.row]
            category = itemCategory
            tableView.reloadData()
            delegate?.didSelect(category: category!)
        }
    }

}

//MARK: - Retrieve Categories
extension CategoryTableVC: NSFetchedResultsControllerDelegate {
    func getCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let nameSort = NSSortDescriptor(key: "categoryName", ascending: true)
        request.sortDescriptors = [nameSort]

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: K.context, sectionNameKeyPath: nil, cacheName: nil)

        controller.delegate = self
        self.categories = controller

        do {
            try controller.performFetch()
        } catch let err {
            print (err)
        }
        tableView.reloadData()
    }
}

extension CategoryTableVC: SelectCategoryDelegate {
    func didSelect(category: Category) {
    }
}
