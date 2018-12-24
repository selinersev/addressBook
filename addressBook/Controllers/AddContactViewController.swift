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
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK : - Properties
    let defaults = UserDefaults.standard
    weak var delegate : DataSendDelegate?
    var editableContact = Contact()
    var editingMode = false
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        let contact = editingMode ? self.editableContact : Contact()
        if isValid(){
            createContact(contact: contact)
        }
        delegate?.sendData(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
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
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func formatNumber(number: String) -> String {
        let phoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format = "(000) 000 00 00"
        var result = ""
        var index = phoneNumber.startIndex
        for char in format {
            if char == "0" {
                result.append(phoneNumber[index])
                index = phoneNumber.index(after: index)
            } else {
                result.append(char)
            }
        }
        return "+90 "+result
    }
    
    func isValid() -> Bool{
        guard let nameField = nameTextField.text, !nameField.isEmpty else {
            showAlert(message: "Name field can not be empty")
            return false
        }
        guard let phoneField = phoneTextField.text, !phoneField.isEmpty && phoneField.count == 10 else {
            showAlert(message: "Phone Number can not be empty")
            return false
        }
        return true
    }
    
    func createContact(contact: Contact){
        guard let nameField = nameTextField.text else {return}
        guard let surnameField = surnameTextField.text else {return}
        guard let phoneField = phoneTextField.text else {return}
        guard let companyField = companyTextField.text else {return}
        contact.phone = formatNumber(number: phoneField)
        contact.surname = surnameField
        contact.name = nameField
        contact.company = companyField
    }

    @objc func doneClicked(){
        view.endEditing(true)
    }
}

