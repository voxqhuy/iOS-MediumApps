//
//  Item.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/14/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Trigger the changes immediately after font settings are changed on the device
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
    
}
