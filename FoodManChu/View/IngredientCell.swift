//
//  IngredientCell.swift
//  FoodManChu
//
//  Created by Jadson on 7/07/22.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var ingredientThumb: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    
    func configureCell(_ ingreditent: Ingredients) {
        ingredientName.text = ingreditent.ingredientName
        ingredientThumb.image = ingreditent.image?.image as? UIImage ?? UIImage(named: "imagePick")
    }

}
