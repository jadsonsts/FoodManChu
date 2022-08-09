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
                    //destination.category = recipe?.category
                }

            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem){
        if let object = recipe {
            performSegue(withIdentifier: K.Segues.addEditRecipe, sender: object)
        }
        
    }


}

//MARK: - Protocol conformance
extension RecipeDetailsVC: UpdatedRecipeDelegate {
    func getUpdatedRecipe(recipe: Recipe) {
        self.recipe = recipe
        loadRecipe()
    }
}


extension UIViewController {
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]
        
        let stringAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")
        
        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }
}



