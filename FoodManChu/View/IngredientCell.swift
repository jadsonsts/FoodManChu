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
    @IBOutlet weak var canEditImageView: UIView!
    
    func configureCell(_ ingreditent: Ingredients) {
        ingredientName.text = ingreditent.ingredientName
        ingredientThumb.image = ingreditent.image?.image as? UIImage ?? UIImage(named: "imagePick")
        
        if ingreditent.canEdit {
            canEditImageView.backgroundColor = .systemTeal
            canEditImageView.layer.cornerRadius = 5
        } else {
            canEditImageView.backgroundColor = .lightGray
            canEditImageView.layer.cornerRadius = 5
        }
    }

}
