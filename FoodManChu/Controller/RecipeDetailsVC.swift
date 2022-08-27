//
//  RecipeDetailsVC.swift
//  FoodManChu
//
//  Created by Jadson on 5/07/22.
//

import UIKit
import CoreData


class RecipeDetailsVC: UIViewController {
    
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeDescripton: UITextView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeIngredientList: UITextView!
    @IBOutlet weak var recipeDirections: UITextView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe != nil {
            loadRecipe()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        reloadData()
    }
    
    func loadRecipe() {
        
        guard let ingredients = recipe?.ingredients?.allObjects as? [Ingredients] else { return }
        
        if let recipe = recipe {
            recipeName.text = recipe.recipeName
            recipeDescripton.text = recipe.recipeDescription ?? "No Description Available"
            thumb.image = recipe.image?.image as? UIImage ?? UIImage(named: "imagePick")
            recipeDirections.text = recipe.cookInstructions ?? "No Instructions Available"
            recipeTime.text = recipe.prepTime
            recipeCategory.text = recipe.category?.categoryName
            recipeIngredientList.attributedText = bulletPointList(strings: ingredients.map({ $0.ingredientName ?? "No Ingredients"}).sorted())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.addEditRecipe {
            if let destination = segue.destination as? RecipeAddEditTVC {
                if let recipe = sender as? Recipe {
                    destination.updatedRecipeDelegate = self
                    destination.recipeToEdit = recipe
                }
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem){
        if let object = recipe {
            performSegue(withIdentifier: K.Segues.addEditRecipe, sender: object)
        }
    }
    
    @IBAction func duplicateRecipeButtonTapped(_ sender: RoundButton) {
        
    }
    
    @IBAction func deleteRecipeButtonTapped(_ sender: RoundButton) {
        if let recipeToDelete = recipe {
            K.context.delete(recipeToDelete)
            K.appDelegate.saveContext()
            reloadData()
            navigationController?.popViewController(animated: true)
            dismiss(animated: true)
        }
    }
    
    func reloadData() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
}

//MARK: - Protocol conformance
extension RecipeDetailsVC: UpdatedRecipeDelegate {
    func getUpdatedRecipe(recipe: Recipe) {
        self.recipe = recipe
        loadRecipe()
    }
}
