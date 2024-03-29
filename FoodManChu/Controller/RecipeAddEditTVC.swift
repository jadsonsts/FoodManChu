//
//  RecipeAddEditTVC.swift
//  FoodManChu
//
//  Created by Jadson on 4/08/22.
//

import UIKit
import CoreData

protocol UpdatedRecipeDelegate {
    func getUpdatedRecipe(recipe: Recipe)
}

class RecipeAddEditTVC: UITableViewController, SelectCategoryDelegate {
    
    func didSelect(category: Category) {
        self.category = category
        updateCategoryLabel()
    }
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeDescription: UITextView! {
        didSet {
            recipeDescription.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
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
    var updatedRecipeDelegate: UpdatedRecipeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCategoryLabel()
        
        if recipeToEdit != nil {
            loadExistingData()
        } else {
            recipeImage.image = UIImage(named: "imagePick")
        }
        
        recipeName.delegate = self
        recipeInstruction.delegate = self
        recipeDescription.delegate = self
        recipePrepTime.delegate = self

    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if recipeImage.image != nil && recipeName.text != "" && recipeDescription.text != "" && recipeInstruction.text != "" && recipeIngredient.text != "" && recipePrepTime.text != "" && recipeCategory.text == "Not Set" {
            
            var recipe: Recipe!
            let photo = Image(context: K.context)
            photo.image = recipeImage.image
            
            if recipeToEdit != nil {
                recipe = recipeToEdit
            } else {
                recipe = Recipe(context: K.context)
            }
            guard let recipeName = recipeName.text, !recipeName.isEmpty,
                  let description = recipeDescription.text, !description.isEmpty,
                  let instructions = recipeInstruction.text, !instructions.isEmpty,
                  let prepTime = recipePrepTime.text, !prepTime.isEmpty,
                  let category = category
            else { return }
            
            recipe.image = photo
            recipe.recipeName = recipeName
            recipe.recipeDescription = description
            recipe.cookInstructions = instructions
            recipe.prepTime = prepTime
            recipe.category = category
            recipe.ingredients = NSSet(array: ingredients)
            
            K.appDelegate.saveContext()
            
            updatedRecipeDelegate?.getUpdatedRecipe(recipe: recipe)
            navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        } else {
            AlertController.ac.alertController(vc: self, title: "Oops!", message: "Please, make sure you filled all fields", style: .alert)
        }
        
        checkForValidTextView(textView: recipeDescription)
        checkForValidTextView(textView: recipeInstruction)
        
        checkForValidTextFields(textField: recipeName)
        checkForValidTextFields(textField: recipePrepTime)
    }
    
    
    func loadExistingData() {
        
        guard let ingredients = recipeToEdit?.ingredients?.allObjects as? [Ingredients] else { return }
        
        if let recipeToEdit = recipeToEdit {
            
            recipeName.text = recipeToEdit.recipeName
            recipeDescription.text = recipeToEdit.recipeDescription
            recipeInstruction.text = recipeToEdit.cookInstructions
            recipeIngredient.attributedText = bulletPointList(strings: ingredients.map({ $0.ingredientName ?? "No Ingredients"}).sorted())
            recipePrepTime.text = recipeToEdit.prepTime
            recipeCategory.text = recipeToEdit.category?.categoryName
            recipeImage.image = recipeToEdit.image?.image as? UIImage ?? UIImage(named: "imagePick")
            
            self.ingredients = ingredients
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.showCategoryList {
            let destination = segue.destination as? CategoryTableVC
            destination?.delegate = self
            destination?.category = category
        } else if segue.identifier == K.Segues.showIngredientsList {
            let destinationIngredients = segue.destination as? IngredientsVC
            destinationIngredients?.ingredientDelegate = self
            destinationIngredients?.canSelectIngredient = true
            if !ingredients.isEmpty {
                for item in ingredients {
                    destinationIngredients?.ingredientSelected[item] = IndexPath()
                }
            }
        }
    }
    
    func updateCategoryLabel() {
        if let category = category {
            recipeCategory.text = category.categoryName
        } else {
            recipeCategory.text = "Not set"
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case indexPathForIngredient:
            performSegue(withIdentifier: K.Segues.showIngredientsList, sender: ingredients)
        case indexPathForCategoryLabel:
            performSegue(withIdentifier: K.Segues.showCategoryList, sender: category)
        case indexPathForImage:
            grabImage()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
        case (indexPathForImage.section, indexPathForImage.row):
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
}
//MARK: - Image Picker Delegate and Navigation Controler Delegate
extension RecipeAddEditTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func grabImage() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Select Image Source", message: nil , preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            recipeImage.image = image
        }
        picker.dismiss(animated: true)
    }
    

    
}

//MARK: - Add Selected Ingredient Protocol
extension RecipeAddEditTVC: AddSelectedIngredient {
    func getSelectedIngredients(_ ingredient: [Ingredients]) {
        ingredients = ingredient
        var list = [String]()
        for item in ingredient {
            list.append(item.ingredientName ?? "")
        }
        recipeIngredient.attributedText = bulletPointList(strings: list.sorted())
        tableView.reloadData()
    }
    
}

//MARK: - Text Field and Text View Delegates
extension RecipeAddEditTVC: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeName.endEditing(true)
        recipePrepTime.endEditing(true)
        
        switch textField {
        case recipeName:
            textField.resignFirstResponder()
        case recipePrepTime:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func checkForValidTextFields(textField: UITextField) {
        if textField.text == "" {
            textField.showError()
        } else {
            textField.hideError()
        }
    }
    
    func checkForValidTextView(textView: UITextView) {
        if textView.text == "" {
            textView.showError()
        } else {
            textView.hideError()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
