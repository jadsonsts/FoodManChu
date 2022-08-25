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
