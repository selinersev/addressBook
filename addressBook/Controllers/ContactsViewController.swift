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
    var contactsDict = [String:[String]]()
    
    var letters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactsTableView.allowsSelection = false
        self.title = "Contacts"
        fetchContacts()
        reloadUI()
    }
    
    func reloadUI(){
        contactList = readItems()
        let tuple = createNameListDict(contacts: contactList)
        contactsDict = tuple.dict
        letters = tuple.letters
        self.contactsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact"{
            let controller : AddContactViewController = segue.destination as! AddContactViewController
            controller.delegate = self
        }
        
        if segue.identifier == "showInfo"{
            let controller = segue.destination as! EditViewController
            guard let selected = sender as? [Contact] else {return}
            controller.contactList = selected
        }
    }
    
    // Delegate Function
    func sendData(contact: Contact) {
        contactList.append(contact)
        self.contactsTableView.reloadData()
        insertItems()
        reloadUI()
    }
    
    // Functions
    func readItems() -> [Contact]{
        guard let data = defaults.object(forKey: "contactList") as? Data else {return []}
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! [Contact]
    }
    
    func insertItems(){
        let data = NSKeyedArchiver.archivedData(withRootObject: contactList)
        defaults.set(data, forKey: "contactList")
    }

    func createNameListDict(contacts: [Contact]) -> (dict:[String:[String]], letters:[Character]){
        let names = contactList.map{$0.name}.compactMap{$0}
        let letters = contactList.map{$0.name.first}.compactMap{$0}
        let uniqueLetters = Array(Set(letters)).sorted()
        var newContacts = [String:[String]]()
        uniqueLetters.forEach { char in
            let firstChar = String(describing: char)
            newContacts[firstChar] = names.filter{$0.first == char}
        }
        return (dict:newContacts, letters:uniqueLetters)
    }
    
    func fetchContacts(){
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access:",err)
                return
            }
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        print(contact.givenName)
                        //print(contact.familyName)
                    })
                    
                } catch let err {
                    print("Failed to enumerate contacts:",err)
                }
            } else {
                print("Access denied..")
            }
        }
    }
}

extension ContactsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = String(letters[section])
        let arr = contactsDict[x] ?? []
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
        contactCell.populate(with: entry)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let x = String(letters[indexPath.section])
            let arr = contactsDict[x] ?? []
            let entry =  arr[indexPath.row]
            
            guard let removeIndex = contactList.firstIndex(where: { $0.name == entry }) else {return}
            contactList.remove(at: removeIndex)
            insertItems()
            reloadUI()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = String(letters[section])
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
}
extension ContactsViewController : UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showInfo", sender: self.contactList[indexPath.row])
    }
}
