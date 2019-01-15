//
//  ContactDetailViewModel.swift
//  addressBook
//
//  Created by Selin Ersev on 15.01.2019.
//  Copyright © 2019 Selin Ersev. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

public class ContactViewModel:NSObject, NSCoding {
    
    private var contact: Contact
    
    public required convenience init?(coder aDecoder: NSCoder) {
        contact.name = aDecoder.decodeObject(forKey: "name") as! String
        contact.surname = aDecoder.decodeObject(forKey: "surname") as! String
        contact.phone = aDecoder.decodeObject(forKey: "phone") as! String
        contact.company = aDecoder.decodeObject(forKey: "company") as! String
        self.init(contact: contact)
    }

    init(contact: Contact) {
        self.contact = contact
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(contact.name, forKey: "name")
        aCoder.encode(contact.surname, forKey: "surname")
        aCoder.encode(contact.phone, forKey: "phone")
        aCoder.encode(contact.company, forKey: "company")
    }
    
}
