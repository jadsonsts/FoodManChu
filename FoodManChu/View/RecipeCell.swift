//
//  RecipeCell.swift
//  FoodManChu
//
//  Created by Jadson on 7/07/22.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    
    
    func configCell(_ recipe: Recipe) {
        thumb.image = recipe.image?.image as? UIImage ?? UIImage(named: "imagePick")
        recipeTitle.text = recipe.recipeName
        recipePrepTime.text = recipe.prepTime
        recipeCategory.text = recipe.category?.categoryName
    }
}
