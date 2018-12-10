//
//  ViewController.swift
//  addressBook
//
//  Created by Selin Ersev on 27.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    //MARK : - Properties
    let defaults = UserDefaults.standard
    weak var delegate : DataSendDelegate?
    var editableContact = Contact()
    var editingMode = false
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        let contact = editingMode ? self.editableContact : Contact()
        createContact(contact: contact)
        delegate?.sendData(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editContact()
        self.hideKeyboardWhenSwipe()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: false)
        nameTextField.inputAccessoryView = toolBar
        surnameTextField.inputAccessoryView = toolBar
        phoneTextField.inputAccessoryView = toolBar
        companyTextField.inputAccessoryView = toolBar
    }
    
    func editContact(){
        nameTextField.text = editableContact.name
        surnameTextField.text = editableContact.surname
        phoneTextField.text = editableContact.phone
        companyTextField.text = editableContact.company
    }
    
    func createContact(contact: Contact){
        guard let nameField = nameTextField.text else {return}
        contact.name = nameField
        guard let surnameField = surnameTextField.text else {return}
        contact.surname = surnameField
        guard let phoneField = phoneTextField.text else {return}
        contact.phone = phoneField
        guard let companyField = companyTextField.text else {return}
        contact.company = companyField
    }

    @objc func doneClicked(){
        view.endEditing(true)
    }
}

