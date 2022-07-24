//
//  Constants.swift
//  FoodManChu
//
//  Created by Jadson on 7/07/22.
//

import Foundation
import UIKit

enum K {
    static var materialKey: Bool = false
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    static let recipeCellID = "RecipeCell"
    static let ingredientCellID = "IngredientCell"
    
    
    enum Segues {
        static let addNewRecipe = "SegueAddNewRecipe"
        static let editRecipe = "SegueEditRecipe"
        static let editIngredient = "SegueEditIngredient"
        static let editNewIngredient = "SegueNewIngredient"
    }
}
