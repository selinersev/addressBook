//
//  ViewController.swift
//  addressBook
//
//  Created by Selin Ersev on 27.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit
import Cartography

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var nameTextField = UITextField()
    private lazy var surnameTextField = UITextField()
    private lazy var phoneTextField = UITextField()
    private lazy var companyTextField = UITextField()
    
    private lazy var saveButton = UIButton()
    private lazy var nameLabel = UILabel()
    private lazy var surnameLabel = UILabel()
    private lazy var phoneNumberLabel = UILabel()
    private lazy var companyLabel = UILabel()
    private lazy var labelStackView = UIStackView()
    private lazy var textFieldStackView = UIStackView()
    private lazy var baseStackView = UIStackView()

    private lazy var closeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(closeButtonAction))

    let defaults = UserDefaults.standard
    weak var delegate : DataSendDelegate?
    var editableContact = Contact()
    var editingMode = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSaveButton()
        setUpLabels()
        setUpTextFields()
        setUpBaseStackView()
        
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
    
    func setUpBaseStackView() {
        baseStackView.addArrangedSubview(labelStackView)
        baseStackView.addArrangedSubview(textFieldStackView)
        baseStackView.axis = .horizontal
        textFieldStackView.distribution = .fill
        textFieldStackView.alignment = .fill
        textFieldStackView.spacing = 42
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(baseStackView)
        
        constrain(baseStackView) { baseStackView in
            baseStackView.bottom == baseStackView.superview!.bottom + 205
            baseStackView.leading == baseStackView.superview!.leading + 50
            baseStackView.trailing == baseStackView.superview!.trailing - 50
            baseStackView.top == baseStackView.superview!.top - 130
        }
    }
    
    func setUpTextFields() {
        nameTextField.borderStyle = .line
        nameTextField.placeholder = "Jane"
        nameTextField.backgroundColor = .white
        nameTextField.textColor = .black
        nameTextField.textAlignment = .left
        
        surnameTextField.borderStyle = .line
        surnameTextField.placeholder = "Doe"
        surnameTextField.backgroundColor = .white
        surnameTextField.textColor = .black
        surnameTextField.textAlignment = .left
        
        phoneTextField.borderStyle = .line
        phoneTextField.placeholder = "(000) 000 00 00"
        phoneTextField.backgroundColor = .white
        phoneTextField.textColor = .black
        phoneTextField.textAlignment = .left
        
        companyTextField.borderStyle = .line
        companyTextField.backgroundColor = .white
        companyTextField.textColor = .black
        companyTextField.textAlignment = .left
        
        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(surnameTextField)
        textFieldStackView.addArrangedSubview(phoneTextField)
        textFieldStackView.addArrangedSubview(companyTextField)
        textFieldStackView.axis = .vertical
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.alignment = .fill
        textFieldStackView.spacing = 46
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func setUpLabels() {
        nameLabel.text = "Name"
        surnameLabel.text = "Surname"
        phoneNumberLabel.text = "Phone"
        companyLabel.text = "Company"
        
        nameLabel.font = UIFont(name: "System", size: 17)
        surnameLabel.font = UIFont(name: "System", size: 17)
        phoneNumberLabel.font = UIFont(name: "System", size: 17)
        companyLabel.font = UIFont(name: "System", size: 17)
        
        nameLabel.textAlignment = .left
        surnameLabel.textAlignment = .left
        phoneNumberLabel.textAlignment = .left
        companyLabel.textAlignment = .left
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(surnameLabel)
        labelStackView.addArrangedSubview(phoneNumberLabel)
        labelStackView.addArrangedSubview(companyLabel)
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        labelStackView.alignment = .fill
        labelStackView.spacing = 53
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setUpSaveButton() {
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        view.addSubview(saveButton)
        
        constrain(saveButton,baseStackView) { saveButton, baseStackView in
            saveButton.bottom == saveButton.superview!.bottom + 87
            saveButton.trailing == saveButton.superview!.trailing - 50
            saveButton.leading == saveButton.superview!.leading + 288
            saveButton.top == baseStackView.bottom - 88
        }
    }
    
    func setUpNavBar() {
        self.navigationItem.rightBarButtonItem = closeItem
        self.title = "ADD CONTACT"
    }
    
    @objc func saveButtonAction() {
        let contact = editingMode ? self.editableContact : Contact()
        if isValid(){
            createContact(contact: contact)
        }
        delegate?.sendContact(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
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

