//
//  File.swift
//  addressBook
//
//  Created by Selin Ersev on 27.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

class Contact{
    
    var name: String
    var surname: String
    var phone: String
    var company: String
    
    init(name:String,surname:String,phone:String,company:String) {
        self.name = name
        self.surname = surname
        self.phone = phone
        self.company = company
    }

    convenience init(with contact: CNContact) {
        let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
        self.init(name: contact.givenName, surname: contact.familyName, phone: phoneNumber, company: contact.organizationName)
    }
}
