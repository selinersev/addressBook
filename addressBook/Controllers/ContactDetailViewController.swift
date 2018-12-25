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

    private lazy var nameLabel = UILabel()
    private lazy var phoneNumberLabel = UILabel()
    private lazy var companyLabel = UILabel()
    
    private lazy var editItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editButtonAction))
    
    var contact = Contact()
    var contactList = [Contact]()
    
//    @objc func doneButtonAction() {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
    
    @objc func editButtonAction() {
        let addContactViewController = AddContactViewController()
        navigationController?.pushViewController(addContactViewController, animated: true)
        //self.performSegue(withIdentifier: "editContact", sender: contact)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
        refreshContactInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            let controller = segue.destination as! AddContactViewController
            guard let selected = sender as? Contact else {return}
            controller.editingMode = true
            controller.editableContact = selected
            controller.delegate = self
        }
    }
    
    func refreshContactInfo(){
        nameLabel.text = contact.name + " " + contact.surname
        phoneNumberLabel.text = contact.phone
        companyLabel.text = contact.company
    }
    
    func populateUI(){
        nameLabel.font = UIFont(name: "System Bold", size: 40)
        nameLabel.textAlignment = .left
        phoneNumberLabel.font = UIFont(name: "System", size: 17)
        phoneNumberLabel.textAlignment = .left
        companyLabel.font = UIFont(name: "System", size: 17)
        companyLabel.textAlignment = .left
        self.navigationItem.rightBarButtonItem = editItem
        //self.navigationItem.leftBarButtonItem = doneItem
        self.title = "ADD CONTACT"
        view.addSubview(nameLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(companyLabel)

        constrain(nameLabel, phoneNumberLabel, companyLabel) { nameLabel, phoneNumberLabel, companyLabel in
            nameLabel.leading == nameLabel.superview!.leading + 30
            nameLabel.trailing == nameLabel.superview!.trailing - 30
            nameLabel.top == nameLabel.superview!.top - 66
            nameLabel.bottom == phoneNumberLabel.top + 30
            phoneNumberLabel.leading == phoneNumberLabel.superview!.leading + 30
            phoneNumberLabel.trailing == phoneNumberLabel.superview!.trailing - 30
            phoneNumberLabel.bottom == companyLabel.top + 30
            companyLabel.leading == companyLabel.superview!.leading + 30
            companyLabel.trailing == companyLabel.superview!.trailing - 30
            companyLabel.bottom == companyLabel.superview!.bottom + 381
        }
    }
}
extension ContactDetailViewController: DataSendDelegate{
    func sendContact(contact: Contact) {
        guard let removeIndex = contactList.firstIndex(where: { $0.name == self.contact.name }) else {return}
        contactList.remove(at: removeIndex)
        contactList.append(contact)
        SaveManager.insertItems(contactList: contactList)
        refreshContactInfo()
    }
}

