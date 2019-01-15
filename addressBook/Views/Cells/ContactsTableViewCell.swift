//
//  ContactsTableViewCell.swift
//  addressBook
//
//  Created by Selin Ersev on 29.11.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit
import Cartography

class ContactsTableViewCell: UITableViewCell {
    
    private lazy var nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameLabel)
        constrain(nameLabel) { nameLabel in
            nameLabel.leading == nameLabel.superview!.leading + 25
            nameLabel.trailing == nameLabel.superview!.trailing - 25
            nameLabel.top == nameLabel.superview!.top - 20
            nameLabel.bottom == nameLabel.superview!.bottom + 20
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with contact: String ){
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "System", size: 22)
        nameLabel.text = contact
        
    }
}
