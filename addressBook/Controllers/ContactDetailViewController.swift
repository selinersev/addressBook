//
//  ContactDetailViewController.swift
//  addressBook
//
//  Created by Selin Ersev on 10.12.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class ContactDetailViewController : UIViewController {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    private lazy var phoneNumberLabel = UILabel()
    
    private lazy var companyLabel = UILabel()
    
    private lazy var editItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editButtonAction))
    
    var contact = Contact()
    var contactList = [Contact]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        constraints()
        populateUI()
    }
    
    @objc func editButtonAction() {
        let addContactViewController = AddContactViewController()
        addContactViewController.editingMode = true
        addContactViewController.editableContact = contact
        addContactViewController.delegate = self
        navigationController?.pushViewController(addContactViewController, animated: true)
    }
    
    func constraints(){
        constrain(nameLabel, phoneNumberLabel, companyLabel) { nameLabel, phoneNumberLabel, companyLabel in
            nameLabel.leading == nameLabel.superview!.leading + 30
            nameLabel.trailing == nameLabel.superview!.trailing - 30
            nameLabel.top == nameLabel.superview!.top + 300
            phoneNumberLabel.trailing == phoneNumberLabel.superview!.trailing - 30
            companyLabel.trailing == companyLabel.superview!.trailing - 30
            align(trailing: nameLabel, phoneNumberLabel, companyLabel)
            align(leading: nameLabel, phoneNumberLabel, companyLabel)
            distribute(by: 30, vertically: nameLabel, phoneNumberLabel, companyLabel)
        }
    }
    
    func populateUI(){
        nameLabel.text = contact.name + " " + contact.surname
        phoneNumberLabel.text = contact.phone
        companyLabel.text = contact.company
    }
    
    func setupUI(){
        self.navigationItem.rightBarButtonItem = editItem
        view.addSubview(nameLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(companyLabel)
    }
}
extension ContactDetailViewController: DataSendDelegate{
    func sendContact(contact: Contact) {
        guard let removeIndex = contactList.firstIndex(of: { $0.name == self.contact.name }) else {return}
        contactList.remove(at: removeIndex)
        contactList.append(contact)
        SaveManager.insertItems(contactList: contactList)
        populateUI()
    }
}

