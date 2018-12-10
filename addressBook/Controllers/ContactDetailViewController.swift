//
//  ContactDetailViewController.swift
//  addressBook
//
//  Created by Selin Ersev on 10.12.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailViewController : UIViewController,DataSendDelegate {
    func sendData(contact: Contact) {
        guard let removeIndex = contactList.firstIndex(where: { $0.name == self.contact.name }) else {return}
        contactList.remove(at: removeIndex)
        contactList.append(contact)
        SaveManager.insertItems(contactList: contactList)
        refreshContactInfo()
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    var contact = Contact()
    var contactList = [Contact]()
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "editContact", sender: contact)
    }
    override func viewDidLoad() {
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
}
