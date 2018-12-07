//
//  SaveManager.swift
//  addressBook
//
//  Created by Selin Ersev on 4.12.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation

class SaveManager{
    
    let defaults = UserDefaults.standard
    var contactList = [Contact]()

    
    func insertItems(){
        let data = NSKeyedArchiver.archivedData(withRootObject: contactList)
        defaults.set(data, forKey: "contactList")
        
    }
    
    func readItems(){
        guard let data = defaults.object(forKey: "contactList") as? Data else {return}
        contactList = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Contact]
    }
    
}
