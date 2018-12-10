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


class Contact: NSObject,NSCoding{
    
    var name : String = ""
    var surname : String = ""
    var phone : String = ""
    var company : String = ""
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let surname = aDecoder.decodeObject(forKey: "surname") as! String
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        let company = aDecoder.decodeObject(forKey: "company") as! String
        self.init(name: name,surname: surname,phone: phone,company: company)
    }
    
    init(name:String,surname:String,phone:String,company:String) {
        self.name = name
        self.surname = surname
        self.phone = phone
        self.company = company
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(surname, forKey: "surname")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(company, forKey: "company")
    }
}
