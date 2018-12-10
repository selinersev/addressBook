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
    let defaults = UserDefaults.standard
    var contactsDict = [String:[Contact]]()
    var letters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        fetchContacts()
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
            //self.dismiss(animated: true, completion: nil)
        }
    }

    func sendData(contact: Contact) {
        contactList.append(contact)
        self.contactsTableView.reloadData()
        SaveManager.insertItems(contactList: contactList)
        reloadUI()
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
    
    func fetchContacts(){
        if let shouldFetch = defaults.object(forKey: "isContactFetched") as? Bool, shouldFetch != true { // First User
            let newContact = Contact()
            let store = CNContactStore()
            
            store.requestAccess(for: .contacts) { (granted, err) in
                if let err = err {
                    print("Failed to request access:",err)
                    return
                }
                if granted {
                    print("Access granted")
                    
                    let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
                    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                    
                    do {
                        try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                            
                            newContact.name = contact.givenName
                            newContact.surname = contact.familyName
                            guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {return}
                            newContact.phone = phoneNumber
                            self.contactList.append(newContact)
                            SaveManager.insertItems(contactList: self.contactList)
                            self.reloadUI()
                        })
                        
                    } catch let err {
                        print("Failed to enumerate contacts:",err)
                    }
                } else {
                    print("Access denied..")
                }
                self.defaults.set(true, forKey: "isContactFetched")
            }
        } else { // Already member
            self.contactList = SaveManager.readItems()
            reloadUI()
        }
    }
}

extension ContactsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = String(letters[section])
        guard let y = contactsDict[x] else {return 0}
        let arr = y
        return arr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = String(letters[indexPath.section])
        let arr = contactsDict[x] ?? []
        let entry =  arr[indexPath.row]
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        contactCell.populate(with: entry.name)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let x = String(letters[indexPath.section])
            guard let y = contactsDict[x] else {return}
            let arr = y
            let entry = arr[indexPath.row]
            
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
        let x = String(letters[indexPath.section])
        let arr = contactsDict[x] ?? []
        let entry =  arr[indexPath.row]
        self.performSegue(withIdentifier: "showInfo", sender: entry)
    }
}
