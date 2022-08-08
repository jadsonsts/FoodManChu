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

class RecipeAddEditTVC: UITableViewController {
    
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
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var category: Category?
    private var categoryForPicker = [Category]()
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
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        getCategories()
        
        if recipeToEdit != nil {
            loadExistingData()
        } else {
            recipeImage.image = UIImage(named: "imagePick")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    
    func loadExistingData() {
        if let recipeToEdit = recipeToEdit, let recipeIngredients = recipeToEdit.ingredients?.allObjects as? [Ingredients], let image = recipeToEdit.image?.image as? UIImage {
             
            recipeName.text = recipeToEdit.recipeName
            recipeDescription.text = recipeToEdit.recipeDescription
            recipeInstruction.text = recipeToEdit.cookInstructions
            recipeIngredient.attributedText = bulletPointList(strings: recipeIngredients.map({ $0.ingredientName ?? "No Ingredients"}).sorted())
            recipePrepTime.text = recipeToEdit.prepTime
            recipeCategory.text = recipeToEdit.category?.categoryName
            recipeImage.image = image
        }
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
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
        if indexPath == indexPathForImage {
            return 200
        } else if indexPath == indexPathForCategoryPicker && isCategoryPickersShown {
            return 0
        }
        return UITableView.automaticDimension
    }
    
}

//MARK: - UIPicker Setup

extension RecipeAddEditTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryForPicker.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = categoryForPicker[row]
        return category.categoryName
    }
}

//MARK: - Retrieve Categories
extension RecipeAddEditTVC {
    func getCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let nameSort = NSSortDescriptor(key: "categoryName", ascending: true)
        request.sortDescriptors = [nameSort]
        
        do {
            self.categoryForPicker = try K.context.fetch(request)
            self.categoryPicker.reloadAllComponents()
        } catch let err {
            print (err)
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

