//
//  RoundButton.swift
//  FoodManChu
//
//  Created by Jadson on 24/07/22.
//

import UIKit
import CloudKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        //MARK: Corner radius
        self.layer.cornerRadius = self.frame.height / 4

        //MARK: Shadow
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.systemGray.cgColor
    }

}

class CustomTxtField: UITextField {
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red: 222/255, green: 223/255, blue: 233/255, alpha: 1.0)
        self.layer.cornerRadius = self.frame.height / 3
    }
}
