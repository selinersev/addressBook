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
import Cartography

protocol DataSendDelegate: class {
    func sendContact(contact: Contact)
}

class ContactsViewController : UIViewController, DataSendDelegate {

    var contactList = [Contact]()
    var contactsDict = [String:[Contact]]()
    var letters = [Character]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: "contactCell")
        tableView.separatorColor = .white
        return tableView
    }()
    
    private lazy var addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addNewContact))

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        self.title = "CONTACTS"
        self.navigationItem.rightBarButtonItem = addItem
        
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
    
    @objc func addNewContact() {
        let addContactViewController = AddContactViewController()
        navigationController?.pushViewController(addContactViewController, animated: true)
        addContactViewController.delegate = self
    }
    
    func reloadUI(){
        contactList = SaveManager.readItems()
        let tuple = createNameListDict(contacts: contactList)
        contactsDict = tuple.dict
        letters = tuple.letters
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func sendContact(contact: Contact) {
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
    
    func constraints(){
        constrain(tableView) { tableView in
            tableView.edges == inset(tableView.superview!.edges, 0, 0, 0, 0)
//            tableView.leading == tableView.superview!.leading
//            tableView.trailing == tableView.superview!.trailing
//            tableView.top == tableView.superview!.top
//            tableView.bottom == tableView.superview!.bottom
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
        let contactDetailViewController = ContactDetailViewController()
        navigationController?.pushViewController(contactDetailViewController, animated: true)
        guard let selected = entry as? Contact else {return}
        contactDetailViewController.contact = selected
        contactDetailViewController.contactList = contactList
    }
}
