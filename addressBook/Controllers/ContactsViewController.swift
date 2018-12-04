//
//  File.swift
//  addressBook
//
//  Created by Selin Ersev on 29.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import UIKit

class ContactsViewController : UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    @IBAction func addNewContact(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addNewContact", sender: contactList)
        
    }
    var contactList = [Contact]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactsTableView.allowsSelection = false
        self.title = "Contacts"
        self.contactsTableView.reloadData()
        readItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact"{
            let controller = segue.destination as! ViewController
            guard let selected = sender as? [Contact] else {return}
            controller.contactList = selected
        }
        
        if segue.identifier == "showInfo"{
            let controller = segue.destination as! InfoViewController
            guard let selected = sender as? [Contact] else {return}
            controller.contactList = selected
        }
    }
    
    func readItems(){
        guard let data = defaults.object(forKey: "contactList") as? Data else {return}
        //contactList = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Contact]
        contactList = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Contact]
        
    }
    
    func insertItems(){
        //let data = NSKeyedArchiver.archivedData(withRootObject: contactList)
        //defaults.set(data, forKey: "contactList")
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        coder.encode(contactList, forKey: NSKeyedArchiveRootObjectKey)
        let data = coder.encodedData
        defaults.set(data, forKey: "contactList")
        
        
        
    }

}

extension ContactsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry =  self.contactList[indexPath.row].name
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        contactCell.populate(with: entry)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            contactList.remove(at: indexPath.row)
            insertItems()
            self.contactsTableView.reloadData()
        }
    }
    
}
extension ContactsViewController : UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showInfo", sender: self.contactList[indexPath.row])
    }
}
