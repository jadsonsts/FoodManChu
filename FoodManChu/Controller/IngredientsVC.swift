//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by Jadson on 5/07/22.
//

import UIKit
import CoreData
import SwipeCellKit

class IngredientsVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients: NSFetchedResultsController <Ingredients>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
//        generateData()
        loadIngredients()
        
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
//MARK: - TABLE VIEW METHODS
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.ingredientCellID, for: indexPath) as? SwipeTableViewCell else { return UITableViewCell()}
        configureCell(cell as! IngredientCell, indexPath: indexPath)
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let ingredientToDelete = ingredients?.object(at: indexPath) {
                K.context.delete(ingredientToDelete)
                K.appDelegate.saveContext()
                tableView.reloadData()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.frame = CGRect(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "Ingredients in Grey mark are default. Ingredients with Teal mark can."
        label.font = UIFont(name: "Avenir", size: 14)
        label.textColor = .black
        label.numberOfLines = 0
        headerView.backgroundColor = .systemGray5
        headerView.layer.cornerRadius = 4
        headerView.addSubview(label)
        
        return headerView
        
    }
    
}
//MARK: - SWIPE TABLE VIEW CELL DELEGATE
extension IngredientsVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete pressed")
        }
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            //will perform segue
            print("edit pressed")
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
//        deleteAction.image = UIImage(systemName: "trash")
        editAction.image = UIImage(named: "pencil-icon")
        editAction.backgroundColor = .systemTeal
        
        

        return [deleteAction, editAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
//MARK: - SEARCH BAR METHODS
extension IngredientsVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        
        request.predicate = NSPredicate(format: "ingredientName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "ingredientName", ascending: true)]
        
        loadIngredients(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadIngredients()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - RESULTS CONTROLLER METHODS
extension IngredientsVC: NSFetchedResultsControllerDelegate {
    func generateData() {
        
        let dictionary = ["Allspice":"allspice", "Baking Powder":"bakingPowder", "Baking Soda":"bakingSoda" ,"Baking Sugar":"bakingSugar", "Bay Leaves":"bayLeaves", "Beef":"beef", "Black Peppercorns":"blackPeppercorns", "Breadcrumbs":"breadcrumbs", "Butter":"butter","Canned Tomatoes":"cannedTomatoes", "Canola Oil":"canolaOil","Capers":"capers", "Cayenne Pepper":"cayennePepper", "Chilli Powder":"chilliPowder", "Cinnamon":"cinnamon", "Cloves":"cloves", "Cumin":"Cumin", "Curry Powder":"curryPowder", "Eggs":"eggs", "Flour":"flour", "Garlic":"garlic", "Ginger":"ginger", "Ground Coriander":"groundCoriander", "Honey":"honey", "Italian Seasoning":"ItalianSeasoning", "Ketchup":"ketchup", "Lentils":"lentils", "Mayonnaise":"Mayonnaise", "Milk":"milk", "Nutmeg":"nutmeg", "Olives":"olives", "Onion":"onion", "Oregano":"Oregano", "Panko":"panko", "Paprika":"paprika", "Pasta":"pasta", "Peanut Butter":"peanutButter", "Potatoes":"potatoes", "Quinoa":"quinoa", "Red Onion":"redOnion", "Rice":"rice", "RiceVinegar":"riceVinegar", "Rosemary":"rosemary", "Salmon":"salmon", "Salsa":"salsa", "Soy Sauce":"soySauce", "Sugar":"sugar", "Thyme":"Thyme", "Tomatoes":"tomatoes", "Tuna":"tuna", "White Vinegar":"whiteVinegar"]
        
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
    
    func loadIngredients(with request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()) {
        
        request.sortDescriptors = [NSSortDescriptor(key: "ingredientName", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: request,
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
        
        tableView.reloadData()
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
