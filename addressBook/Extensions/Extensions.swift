//
//  File.swift
//  addressBook
//
//  Created by Selin Ersev on 29.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import UIKit

extension AddContactViewController {
    func hideKeyboardWhenSwipe() {
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AddContactViewController.dismissKeyboard))
        swipe.cancelsTouchesInView = false
        swipe.direction = .down
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

