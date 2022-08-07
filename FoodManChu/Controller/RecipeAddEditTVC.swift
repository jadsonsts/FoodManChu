//
//  RecipeAddEditTVC.swift
//  FoodManChu
//
//  Created by Jadson on 4/08/22.
//

import UIKit

protocol UpdatedRecipeDelegate {
    func getUpdatedRecipe(recipe: Recipe)
}

class RecipeAddEditTVC: UITableViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeDescription: UITextView! {
        didSet {
            recipeDescription.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var recipeInstruction: UITextView! {
        didSet {
            recipeInstruction.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    @IBOutlet weak var recipePrepTime: UITextField!
    @IBOutlet weak var recipeIngredient: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    
    var category: Category?
    var ingredients = [Ingredients]()
    var recipeToEdit: Recipe?
    
    let indexPathForImage = IndexPath(row: 0, section: 0)
    let indexPathForIngredient = IndexPath(row: 0, section: 4)
    let indexPathForCategoryLabel = IndexPath(row: 0, section: 6)
    let indexPathForCategoryPicker = IndexPath(row: 1, section: 6)
    var updatedRecipeDelegate: UpdatedRecipeDelegate?
    
    var isCategoryPickersShown: Bool = false {
        didSet {
            categoryPicker.isHidden = !isCategoryPickersShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if recipeToEdit != nil {
            loadExistingData()
        }
    }
    
    func loadExistingData() {
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case indexPathForIngredient:
            performSegue(withIdentifier: K.Segues.showIngredientsList, sender: Bool(true))
        case indexPathForCategoryLabel:
            isCategoryPickersShown = true
        case indexPathForImage:
            grabImage()
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath == indexPathForImage {
            return 200
        } else if indexPath == indexPathForCategoryPicker && isCategoryPickersShown {
            return 40
        }
        return UITableView.automaticDimension
    }

}

extension RecipeAddEditTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func grabImage() {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                recipeImage.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}
