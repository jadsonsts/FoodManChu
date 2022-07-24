//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by Jadson on 5/07/22.
//

import UIKit
import CoreData

class IngredientsVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients: NSFetchedResultsController <Ingredients>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateData()
        attempFetch()
    }
    
}

extension IngredientsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = ingredients?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.ingredientCellID, for: indexPath) as? IngredientCell else { return UITableViewCell()}
        configureCell(cell, indexPath: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func configureCell (_ cell: IngredientCell, indexPath: IndexPath) {
        guard let ingredient = ingredients?.object(at: indexPath) else { return }
        cell.configureCell(ingredient)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let ingredients = ingredients?.object(at: indexPath) else { return false}
        if ingredients.canEdit {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension IngredientsVC: NSFetchedResultsControllerDelegate {
    func generateData() {
        
        let ingredients = Ingredients(context: K.context)
        ingredients.ingredientName = "pasta"
        ingredients.canEdit = false
        
        let ingredients1 = Ingredients(context: K.context)
        ingredients1.ingredientName = "cheese"
        ingredients1.canEdit = false
        
        let ingredients2 = Ingredients(context: K.context)
        ingredients2.ingredientName = "ham"
        ingredients2.canEdit = false
        
        let ingredients3 = Ingredients(context: K.context)
        ingredients3.ingredientName = "minced beef"
        ingredients3.canEdit = false
        
        let ingredients4 = Ingredients(context: K.context)
        ingredients4.ingredientName = "tomato sauce"
        ingredients4.canEdit = false
        
        K.appDelegate.saveContext()
        
    }
    
    func attempFetch() {
        let fetchRequest: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        
        let allIngredients = NSSortDescriptor(key: "ingredientName", ascending: false)
        fetchRequest.sortDescriptors = [allIngredients]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: K.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        controller.delegate = self
        self.ingredients = controller
        do {
            try controller.performFetch()
        } catch let err {
            print (err)
        }
        
    }
}
