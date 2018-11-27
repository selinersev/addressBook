//
//  ViewController.swift
//  addressBook
//
//  Created by Selin Ersev on 27.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        var contact = Contact()
        guard let nameField = nameTextField.text else {return}
        contact.name = nameField
        guard let surnameField = surnameTextField.text else {return}
        contact.surname = surnameField
        guard let phoneField = phoneTextField.text else {return}
        contact.phone = phoneField
        guard let companyField = companyTextField.text else {return}
        contact.company = companyField

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

