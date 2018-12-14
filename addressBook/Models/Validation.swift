//
//  Validation.swift
//  addressBook
//
//  Created by Selin Ersev on 14.12.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import Foundation

enum Alert {
    case success
    case failure
    case error
}

enum Valid {
    case success
    case failure(Alert, AlertMessages)
}
enum ValidationType {
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
}
enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{10,14}" // PhoneNo 10-14 Digits
}
enum AlertMessages: String {
    case inValidEmail = "InvalidEmail"
    case invalidFirstLetterCaps = "First Letter should be capital"
    case inValidPhone = "Invalid Phone"
    case invalidAlphabeticString = "Invalid String"
    case inValidPSW = "Invalid Password"
    
    case emptyPhone = "Empty Phone"
    case emptyEmail = "Empty Email"
    case emptyFirstLetterCaps = "Empty"
    case emptyAlphabeticString = "Empty String"
    case emptyPSW = "Empty Password"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
