//
//  Constants.swift
//  FoodManChu
//
//  Created by Jadson on 7/07/22.
//

import UIKit

enum K {
    static var materialKey: Bool = false
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    static let recipeCellID = "RecipeCell"
    static let ingredientCellID = "IngredientCell"
    static let ingredientRecipeCellID = "ingredientRecipeCell"
    static let categoryCell = "CategoryCell"
    
    
    enum Segues {
        static let addEditRecipe = "SegueAddEditRecipe"
        static let viewRecipe = "SegueViewRecipe"
        static let editIngredient = "SegueEditIngredient"
        static let editNewIngredient = "SegueNewIngredient"
        static let showIngredientsList = "showIngredients"
        static let showCategoryList = "SelectCategory"
    }
}
