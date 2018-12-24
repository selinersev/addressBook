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
        save(object: data, for: "contactList")
    }
    
    class func readItems() -> [Contact]{
        guard let data = get(for:"contactList") as? Data else {return []}
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! [Contact]
    }
    
    class func save(object:Any, for key:String){
        UserDefaults.standard.set(object, forKey: key)
    }
    
    class func get(for key:String) -> Any?{
        return UserDefaults.standard.object(forKey: key)
    }
}
