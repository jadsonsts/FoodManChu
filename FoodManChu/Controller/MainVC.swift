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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateTestData()
        attemptFetch()
        
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
        return 260
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCell (_ cell: RecipeCell, indexPath: IndexPath) {
        guard let recipe = recipe?.object(at: indexPath) else { return }
        cell.configCell(recipe)
        
    }
    
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func generateTestData() {
             
        
        let category = Category(context: K.context)
        category.categoryName = "Meat"
        
        
        let recipe = Recipe(context: K.context)
        recipe.recipeName = "Lasanha"
        recipe.recipeDescription = "Lasanha (lasagne em italiano) é tanto um tipo de massa alimentícia formada por fitas largas, como também um prato, por vezes chamado lasanha ao forno, feito com essas fitas colocadas em camadas, e entremeadas com recheio (queijo, presunto, carne moída ou outros) e molho."
        recipe.cookInstructions = "Preheat oven to 375 degrees F (190 degrees C). Bring a large pot of lightly salted water to a boil. Add noodles and cook for 8 to 10 minutes or until al dente; drain and set aside..."
        recipe.category?.categoryName = category.categoryName
        recipe.prepTime = "45min"
        //recipe.ingredients?.addingObjects(from: [ingredients])
        
        K.appDelegate.saveContext()
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        let allRecipes = NSSortDescriptor(key: "recipeName", ascending: false)
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
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

