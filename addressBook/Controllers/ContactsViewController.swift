//
//  File.swift
//  addressBook
//
//  Created by Selin Ersev on 29.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

protocol DataSendDelegate: class {
    func sendData(contact: Contact)
}

class ContactsViewController : UIViewController,DataSendDelegate {

    @IBOutlet weak var contactsTableView: UITableView!
    
    @IBAction func addNewContact(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addNewContact", sender: contactList)
    }
    var contactList = [Contact]()
    var contactsDict = [String:[Contact]]()
    var letters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        ContactService.fetchContacts { (contacts) in
            self.contactList = contacts
            SaveManager.insertItems(contactList: contacts)
            self.reloadUI()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }
    
    func reloadUI(){
        contactList = SaveManager.readItems()
        let tuple = createNameListDict(contacts: contactList)
        contactsDict = tuple.dict
        letters = tuple.letters
        DispatchQueue.main.async {
            self.contactsTableView.reloadData()
        }
    }
    
    func sendData(contact: Contact) {
        contactList.append(contact)
        SaveManager.insertItems(contactList: contactList)
        reloadUI()
    }
    
    func getSelectedContacts(for section:Int) -> [Contact] {
        let firstLetter = String(letters[section])
        let selectedContacts = contactsDict[firstLetter] ?? []
        return selectedContacts
    }
    
    func getContacts(for indexPath:IndexPath) -> Contact{
        return getSelectedContacts(for: indexPath.section)[indexPath.row]
    }
    
    func createNameListDict(contacts: [Contact]) -> (dict:[String:[Contact]], letters:[Character]){
        let names = contactList
        let letters = contactList.map{$0.name.first}.compactMap{$0}
        let uniqueLetters = Array(Set(letters)).sorted()
        var newContacts = [String:[Contact]]()
        uniqueLetters.forEach { char in
            let firstChar = String(describing: char)
            newContacts[firstChar] = names.filter{$0.name.first == char}
        }
        return (dict:newContacts, letters:uniqueLetters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact"{
            let controller : AddContactViewController = segue.destination as! AddContactViewController
            controller.delegate = self
        }
        
        if segue.identifier == "showInfo"{
            let controller = segue.destination as! ContactDetailViewController
            guard let selected = sender as? Contact else {return}
            controller.contact = selected
            controller.contactList = contactList
        }
    }
}

extension ContactsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSelectedContacts(for: section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry =  getContacts(for: indexPath)
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        contactCell.populate(with: entry.name)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let entry = getContacts(for: indexPath)
            guard let removeIndex = contactList.firstIndex(where: { $0.name == entry.name }) else {return}
            contactList.remove(at: removeIndex)
            SaveManager.insertItems(contactList: contactList)
            reloadUI()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = String(letters[section])
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)
        return label
    }
    
}

extension ContactsViewController : UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry =  getContacts(for: indexPath)
        self.performSegue(withIdentifier: "showInfo", sender: entry)
    }
}
