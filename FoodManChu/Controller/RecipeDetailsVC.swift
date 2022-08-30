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
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeIngredientList: UITextView!
    @IBOutlet weak var recipeDirections: UITextView!
    
    var recipe: Recipe?
    var category: Category?
    
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
            recipeDescription.text = recipe.recipeDescription ?? "No Description Available"
            thumb.image = recipe.image?.image as? UIImage ?? UIImage(named: "imagePick")
            recipeDirections.text = recipe.cookInstructions ?? "No Instructions Available"
            recipePrepTime.text = recipe.prepTime
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

        //recipeToDuplicate
        
        guard let ingredients = recipe?.ingredients?.allObjects as? [Ingredients] else { return }
        
        var recipeToDuplicate: Recipe!
        let photo = Image(context: K.context)
        photo.image = thumb.image
        
        recipeToDuplicate = Recipe(context: K.context)
        
        guard let recipeName = recipeName.text, !recipeName.isEmpty,
              let description = recipeDescription.text, !description.isEmpty,
              let instructions = recipeDirections.text, !instructions.isEmpty,
              let prepTime = recipePrepTime.text, !prepTime.isEmpty,
              let category = category
        else { return }
        
        recipeToDuplicate.image = photo
        recipeToDuplicate.recipeName = ("Copy of \(recipeName)")
        recipeToDuplicate.recipeDescription = description
        recipeToDuplicate.cookInstructions = instructions
        recipeToDuplicate.prepTime = prepTime
        recipeToDuplicate.category = category
        recipeToDuplicate.ingredients = NSSet(array: ingredients)
        
        K.appDelegate.saveContext()
        
        
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
