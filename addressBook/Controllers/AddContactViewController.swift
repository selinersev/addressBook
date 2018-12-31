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
    
    private lazy var nameTextField: UITextField = {
        return setTextField(placeholder: "Jane")
    }()
    private lazy var surnameTextField: UITextField = {
        return setTextField(placeholder: "Doe")
    }()
    private lazy var phoneTextField: UITextField = {
        return setTextField(placeholder: "(000) 000 00 00")
    }()
    private lazy var companyTextField: UITextField = {
        return setTextField(placeholder: "")
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        return setLabel(text: "Name")
    }()
    private lazy var surnameLabel: UILabel = {
        return setLabel(text: "Surname")
    }()
    private lazy var phoneNumberLabel: UILabel = {
        return setLabel(text: "Phone Number")
    }()
    private lazy var companyLabel: UILabel = {
        return setLabel(text: "Company")
    }()
   
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView.init(arrangedSubviews: [nameLabel,surnameLabel,phoneNumberLabel,companyLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 53
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(surnameTextField)
        stackView.addArrangedSubview(phoneTextField)
        stackView.addArrangedSubview(companyTextField)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 46
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(textFieldStackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 42
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

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
    let toolBar = UIToolbar()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(baseStackView)
        view.addSubview(saveButton)
        contraints()
        editContact()
        self.hideKeyboardWhenSwipe()
        
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: false)
    }
   
    override var inputAccessoryView: UIView{
        return toolBar
    }
    
    @objc func saveButtonAction() {
        let contact = editingMode ? self.editableContact : Contact()
        if isValid(){
            createContact(contact: contact)
        }
        delegate?.sendContact(contact: contact)
        navigationController?.popViewController(animated: true)
    }
    
    func contraints(){
        constrain(baseStackView,saveButton) { baseStackView, saveButton in
            baseStackView.leading == baseStackView.superview!.leading + 50
            baseStackView.trailing == baseStackView.superview!.trailing - 50
            baseStackView.centerY == baseStackView.superview!.centerY
            saveButton.trailing == saveButton.superview!.trailing - 50
            saveButton.top == baseStackView.bottom + 100
        }
    }
    
    func setTextField(placeholder: String) -> UITextField{
        let textField = UITextField()
        textField.borderStyle = .line
        textField.placeholder = placeholder
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.textAlignment = .left
        return textField
    }
    
    func setLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "System", size: 17)
        return label
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

