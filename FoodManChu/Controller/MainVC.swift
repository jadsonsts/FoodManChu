//
//  ViewController.swift
//  FoodManChu
//
//  Created by Jadson on 3/07/22.
//

import UIKit
import CoreData
import SwipeCellKit

class MainVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: NSFetchedResultsController <Recipe>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
//        generateTestData()
        loadRecipes()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    
    @objc func loadList(){
            loadRecipes()
            self.tableView.reloadData()
        }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        fetchRecipeByCategory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.viewRecipe {
            if let destination = segue.destination as? RecipeDetailsVC {
                if let recipe = sender as? Recipe {
                    destination.recipe = recipe
                    destination.category = recipe.category
                }
            }
        } else if segue.identifier == K.Segues.addEditRecipe {
            if let destination = segue.destination as? RecipeAddEditTVC {
                if let recipe = sender as? Recipe {
                    destination.recipeToEdit = recipe
                }
            }
        }
    }
}

//MARK: - TableView DataSource and Delegate
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.recipeCellID, for: indexPath) as? SwipeTableViewCell else { return SwipeTableViewCell() }
        
        configureCell(cell as! RecipeCell, indexPath: indexPath)
        cell.delegate = self
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

//MARK: - SwipeViewCell Delegate
extension MainVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        if recipe?.object(at: indexPath) != nil {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // delete the row
                if let recipeToDelete = self.recipe?.object(at: indexPath) {
                    K.context.delete(recipeToDelete)
                    K.appDelegate.saveContext()
                }
                self.loadRecipes()
            }
            let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                //perform segue to edit
                if let objs = self.recipe?.fetchedObjects, objs.count > 0 {
                        let item = objs[indexPath.row]
                        self.performSegue(withIdentifier: K.Segues.addEditRecipe , sender: item)
                        tableView.reloadData()
                }
            }
            
            deleteAction.image = UIImage(named: "delete-icon")
            editAction.image = UIImage(named: "pencil-icon")
            editAction.backgroundColor = .systemTeal
            
            return [deleteAction, editAction]
            
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

//MARK: - SearchBar Delegate
extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        guard let textSearchBar = searchBar.text else { return }
        request.predicate = NSPredicate(format: "recipeName CONTAINS[cd] %@ OR ingredients.ingredientName CONTAINS[cd] %@ OR recipeDescription CONTAINS[cd] %@ OR prepTime CONTAINS[cd] %@ OR category.categoryName CONTAINS[cd] %@ OR cookInstructions CONTAINS[cd] %@", textSearchBar, textSearchBar, textSearchBar, textSearchBar, textSearchBar, textSearchBar)
        request.sortDescriptors = [NSSortDescriptor(key: "recipeName", ascending: true)]
        
        loadRecipes(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRecipes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - NSFetch Delegate
extension MainVC: NSFetchedResultsControllerDelegate {
    func generateTestData() {
        
        let recipe = Recipe(context: K.context)
        recipe.recipeName = "Feijao de corda"
        let categoryName = Category(context: K.context)
        categoryName.categoryName = "Meat"
        recipe.category = categoryName
        recipe.prepTime = "⏱ 45min"
        
        K.appDelegate.saveContext()
    }
    
    func loadRecipes(with request: NSFetchRequest<Recipe> = Recipe.fetchRequest()) {
        request.sortDescriptors = [NSSortDescriptor(key: "recipeName", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: request,
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
        
        tableView.reloadData()
    }
    
    func fetchRecipeByCategory() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let allRecipes = NSSortDescriptor(key: "recipeName", ascending: true)
        let filterByCategory = NSPredicate(format: "category.categoryName == %@",
                                           segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!)
    
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [allRecipes]
        case 1:
            fetchRequest.predicate = filterByCategory
            fetchRequest.sortDescriptors = [allRecipes]
        case 2:
            fetchRequest.predicate = filterByCategory
            fetchRequest.sortDescriptors = [allRecipes]
        case 3:
            fetchRequest.predicate = filterByCategory
            fetchRequest.sortDescriptors = [allRecipes]
        case 4:
            fetchRequest.predicate = filterByCategory
            fetchRequest.sortDescriptors = [allRecipes]
        case 5:
            fetchRequest.predicate = filterByCategory
            fetchRequest.sortDescriptors = [allRecipes]
        default:
            break
        }
        
        loadRecipes(with: fetchRequest)
    }

}

