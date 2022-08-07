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
    @IBOutlet weak var recipeDescripton: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeIngredientList: UILabel!
    @IBOutlet weak var recipeDirections: UILabel!
    
    var recipe: Recipe?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe != nil {
            title = recipe?.recipeName
            loadRecipe()
        }
    }
    
    func loadRecipe() {
        guard let image = recipe?.image?.image as? UIImage, let ingredient = recipe?.ingredients?.allObjects as? [Ingredients] else { return }
        thumb.image = image
        recipeCategory.text = recipe?.category?.categoryName
        recipeName.text = recipe?.recipeName
        recipeDescripton.text = recipe?.recipeDescription
        recipeTime.text = recipe?.prepTime
        recipeIngredientList.attributedText = bulletPointList(strings: ingredient.map({ $0.ingredientName ?? "No Ingredients"}).sorted())
        recipeDirections.text = recipe?.cookInstructions
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.addEditRecipe {
            if let destination = segue.destination as? RecipeAddEditTVC {
                destination.updatedRecipeDelegate = self
                destination.recipeToEdit = recipe
                destination.category = recipe?.category
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: K.Segues.addEditRecipe, sender: nil)
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



