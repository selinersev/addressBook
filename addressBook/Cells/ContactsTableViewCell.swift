//
//  ContactsTableViewCell.swift
//  addressBook
//
//  Created by Selin Ersev on 29.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
       
    @IBOutlet weak var nameLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(with contact: String ){
        nameLabel.text = contact
        
    }
}
