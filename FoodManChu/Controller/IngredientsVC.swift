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
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.editIngredient {
            if let destination = segue.destination as? IngredientsDetailsVC {
                if let ingredient = sender as? Ingredients {
                    destination.ingreditentToEdit = ingredient
                }
            }
        }
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
        if let objs = ingredients?.fetchedObjects, objs.count > 0 {
            if ingredients?.object(at: indexPath).canEdit == true {
                let item = objs[indexPath.row]
                performSegue(withIdentifier: K.Segues.editIngredient , sender: item)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension IngredientsVC: NSFetchedResultsControllerDelegate {
    func generateData() {
        
        let dictionary: [String : String] = ["Allspice":"allspice", "Baking Powder":"bakingPowder", "Baking Soda":"bakingSoda" ,"Baking Sugar":"bakingSugar", "Bay Leaves":"bayLeaves", "Beef":"beef", "Black Peppercorns":"blackPeppercorns", "Breadcrumbs":"breadcrumbs", "Butter":"butter","Canned Tomatoes":"cannedTomatoes", "Canola Oil":"canolaOil","Capers":"capers", "Cayenne Pepper":"cayennePepper", "Chilli Powder":"chilliPowder", "Cinnamon":"cinnamon", "Cloves":"cloves", "Cumin":"Cumin", "Curry Powder":"curryPowder", "Eggs":"eggs", "Flour":"flour", "Garlic":"garlic", "Ginger":"ginger", "Ground Coriander":"groundCoriander", "Honey":"honey", "Italian Seasoning":"ItalianSeasoning", "Ketchup":"ketchup", "Lentils":"lentils", "Mayonnaise":"Mayonnaise", "Milk":"milk", "Nutmeg":"nutmeg", "Olives":"olives", "Onion":"onion", "Oregano":"Oregano", "Panko":"panko", "Paprika":"paprika", "Pasta":"pasta", "Peanut Butter":"peanutButter", "Potatoes":"potatoes", "Quinoa":"quinoa", "Red Onion":"redOnion", "Rice":"rice", "RiceVinegar":"riceVinegar", "Rosemary":"rosemary", "Salmon":"salmon", "Salsa":"salsa", "Soy Sauce":"soySauce", "Sugar":"sugar", "Thyme":"Thyme", "Tomatoes":"tomatoes", "Tuna":"tuna", "White Vinegar":"whiteVinegar"]
        
        for data in dictionary {
            let ingredients = Ingredients(context: K.context)
            ingredients.ingredientName = data.key
            ingredients.canEdit = false
            let photo = Image(context: K.context)
            photo.image = UIImage (named: data.value)
            ingredients.image = photo
        }
        
        K.appDelegate.saveContext()
        
    }
    
    func attempFetch() {
        let fetchRequest: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        
        let allIngredients = NSSortDescriptor(key: "ingredientName", ascending: true)
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! IngredientCell
                configureCell(cell, indexPath: indexPath)
            }
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
