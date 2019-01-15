//
//  Contacts.swift
//  addressBook
//
//  Created by Selin Ersev on 21.12.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation
import Contacts

class ContactService {
    class func fetchContacts(completionHandler:@escaping (_ result: [Contact]) -> Void){
        var contacts = [Contact]()
        let shouldFetch = SaveManager.get(for: "isContactFetched") as? Bool
        if shouldFetch != true {
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, err) in
                if let err = err {
                    print("Failed to request access:",err)
                    return
                }
                if granted {
                    print("Access granted")
                    let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactOrganizationNameKey]
                    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                    do {
                        try store.enumerateContacts(with: request, usingBlock: { (contact,_) in
                            contacts.append(Contact(with: contact))
                        })
                        completionHandler(contacts)
                    } catch let err {
                        print("Failed to enumerate contacts:",err)
                    }
                } else {
                    print("Access denied..")
                }
                SaveManager.save(object: true, for: "isContactFetched")
            }
        } else {
            completionHandler(SaveManager.readItems())
        }
    }
}
