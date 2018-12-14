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
        saveButton.isEnabled = false
        guard let nameField = nameTextField.text else {return}
        contact.name = nameField
        guard let surnameField = surnameTextField.text else {return}
        contact.surname = surnameField
        guard let phoneField = phoneTextField.text else {return}
        contact.phone = phoneField
        guard let companyField = companyTextField.text else {return}
        contact.company = companyField

        let isValid = validate(values:(ValidationType.stringWithFirstLetterCaps, contact.name), (ValidationType.phoneNo, contact.phone), (ValidationType.stringWithFirstLetterCaps, contact.surname),(ValidationType.stringWithFirstLetterCaps, contact.company))
        switch isValid {
        case .success:
            saveButton.isEnabled = true
        case .failure(_, let message):
            print(message.localized())
        }
    }

    @objc func doneClicked(){
        view.endEditing(true)
    }
    
    func validate(values: (type: ValidationType, inputValue: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .email, .emptyEmail, .inValidEmail)) {
                    return tempValue
                }
            case .stringWithFirstLetterCaps:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringFirstLetterCaps, .emptyFirstLetterCaps, .invalidFirstLetterCaps)) {
                    return tempValue
                }
            case .phoneNo:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .phoneNo, .emptyPhone, .inValidPhone)) {
                    return tempValue
                }
            case .alphabeticString:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringWithSpace, .emptyAlphabeticString, .invalidAlphabeticString)) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .password, .emptyPSW, .inValidPSW)) {
                    return tempValue
                }
            }
        }
        return .success
    }
    
    func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}

