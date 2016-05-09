//
//  CustomCell.swift
//  ToDo
//
//  Created by Maarten Brijker on 08/04/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var toDoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
