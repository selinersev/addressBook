//
//  SaveManager.swift
//  addressBook
//
//  Created by Selin Ersev on 4.12.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation

class SaveManager{
    
    class func insertItems(contactList:[Contact]){
        let data = NSKeyedArchiver.archivedData(withRootObject: contactList)
        UserDefaults.standard.set(data, forKey: "contactList")        
    }
    
    class func readItems() -> [Contact]{
        guard let data = UserDefaults.standard.object(forKey: "contactList") as? Data else {return []}
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! [Contact]
    }
    
}
