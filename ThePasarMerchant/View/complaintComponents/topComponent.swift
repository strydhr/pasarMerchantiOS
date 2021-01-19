//
//  topComponent.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 18/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class topComponent: UITableViewCell {
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var receiptNumber: UILabel!
    @IBOutlet weak var lodgeDate: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    
    @IBOutlet weak var customerAddressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        customerAddressLabel.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
