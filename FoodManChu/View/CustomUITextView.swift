//
//  CustomUITextView.swift
//  FoodManChu
//
//  Created by Jadson on 25/08/22.
//

import UIKit

class CustomUITextView: UITextView {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}

extension UITextView {
    func showError() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
    
    func hideError() {
        layer.borderWidth = 0
        layer.borderColor = nil
    }

}
