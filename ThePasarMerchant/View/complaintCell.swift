//
//  complaintCell.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 18/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class complaintCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var camplaintOrdersLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
