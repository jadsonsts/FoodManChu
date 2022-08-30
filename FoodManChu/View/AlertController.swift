//
//  File.swift
//  FoodManChu
//
//  Created by Jadson on 27/08/22.
//

import UIKit

class AlertController: UIAlertController {
    
    static let ac = AlertController()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func alertController(vc: UIViewController,title: String?, message: String?, style: UIAlertController.Style ) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        vc.present(ac, animated: true, completion: nil)
    }
    
}
