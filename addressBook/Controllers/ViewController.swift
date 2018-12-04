//
//  ViewController.swift
//  addressBook
//
//  Created by Selin Ersev on 27.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    let defaults = UserDefaults.standard
    var contactList = [Contact]()
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        var contact = Contact()
        createContact(contact: contact)
        contactList.append(contact)
        insertItems()
        
        self.performSegue(withIdentifier: "showContactsSegue", sender: contactList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenSwipe()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: false)
        nameTextField.inputAccessoryView = toolBar
        surnameTextField.inputAccessoryView = toolBar
        phoneTextField.inputAccessoryView = toolBar
        companyTextField.inputAccessoryView = toolBar
        readItems()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactsSegue"{
            let controller = segue.destination as! ContactsViewController
            guard let selected = sender as? [Contact] else {return}
            controller.contactList = selected
        }
    }
    
    func insertItems(){
        let data = NSKeyedArchiver.archivedData(withRootObject: contactList)
        defaults.set(data, forKey: "contactList")
        
    }
    
    func readItems(){
        guard let data = defaults.object(forKey: "contactList") as? Data else {return}
        contactList = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Contact]
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

