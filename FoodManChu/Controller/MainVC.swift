//
//  ViewController.swift
//  FoodManChu
//
//  Created by Jadson on 3/07/22.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: NSFetchedResultsController <Recipe>?
    //var category: NSFetchedResultsController <Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateTestData()
        fetchRecipe()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        fetchRecipe()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.viewRecipe {
            if let destination = segue.destination as? RecipeDetailsVC {
                if let recipe = sender as? Recipe {
                    destination.recipe = recipe
                }
            }
        }
    }
}

//MARK: - TableView
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = recipe?.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = recipe?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.recipeCellID, for: indexPath) as? RecipeCell else { return UITableViewCell() }
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = recipe?.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: K.Segues.viewRecipe, sender: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCell (_ cell: RecipeCell, indexPath: IndexPath) {
        guard let recipe = recipe?.object(at: indexPath) else { return }
        cell.configCell(recipe)
        
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func generateTestData() {
        
        let categories = ["Meat","Vegie","Vegan","Paleo","Keto"]

        for category in categories {
            let cat = Category(context: K.context)
            cat.categoryName = category
        }
        
        
        let recipe = Recipe(context: K.context)
        recipe.recipeName = "Feijao de corda"
        let categoryName = Category(context: K.context)
        categoryName.categoryName = categories[1]
        recipe.category = categoryName
        recipe.prepTime = "⏱ 45min"
        
        K.appDelegate.saveContext()
    }
    
    func fetchRecipe() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let allRecipes = NSSortDescriptor(key: "recipeName", ascending: true)
    
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [allRecipes]
        case 1:
            fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@",
                                                 segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!)
            fetchRequest.sortDescriptors = [allRecipes]
        case 2:
            fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@",
                                                 segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!)
            fetchRequest.sortDescriptors = [allRecipes]
        case 3:
            fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@",
                                                 segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!)
            fetchRequest.sortDescriptors = [allRecipes]
        case 4:
            fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@",
                                                 segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!)
            fetchRequest.sortDescriptors = [allRecipes]
        case 5:
            fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@",
                                                 segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!)
            fetchRequest.sortDescriptors = [allRecipes]
        default:
            break
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: K.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        controller.delegate = self
        self.recipe = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err)
        }
    }

}

