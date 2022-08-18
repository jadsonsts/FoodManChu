//
//  IngredientsDetailsVC.swift
//  FoodManChu
//
//  Created by Jadson on 5/07/22.
//

import UIKit
import CoreData

class IngredientsDetailsVC: UIViewController {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var ingredientField: UITextField!
    
    var ingreditentToEdit: Ingredients?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientField.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if ingreditentToEdit != nil {
            loadData()
        }
    }
    

    @IBAction func saveTapped(sender: RoundButton) {
        var ingredient: Ingredients!
        let photo = Image(context: K.context)
        photo.image = thumb.image
        
        if ingreditentToEdit != nil {
            ingredient = ingreditentToEdit
        } else {
            ingredient = Ingredients(context: K.context)
        }
        guard let name = ingredientField.text, !name.isEmpty else { return }
        ingredient.ingredientName = name
        ingredient.canEdit = true
        ingredient.image = photo
        
        K.appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
        
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteTapped(_ sender: RoundButton) {
        if ingreditentToEdit != nil {
            K.context.delete(ingreditentToEdit!)
            K.appDelegate.saveContext()
            dismiss(animated: true)
        } else {
            ingredientField.text = ""
            ingredientField.placeholder = "insert ingredient name"
            thumb.image = UIImage(named: "imagePick")
        }
    }
    
    func loadData() {
        if let ingreditent = ingreditentToEdit {
            ingredientField.text = ingreditent.ingredientName
            thumb.image = ingreditent.image?.image as? UIImage
        }
    }
}

//MARK: - UI Picker/NavigationController Delegate
extension IngredientsDetailsVC: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            thumb.image = image
        }
        picker.dismiss(animated: true)
    }
}

//MARK: - TextField DELEGATE
extension IngredientsDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientField.endEditing(true)
        
        if textField == ingredientField {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
