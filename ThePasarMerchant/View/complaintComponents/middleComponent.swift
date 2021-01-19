//
//  middleComponent.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 19/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class middleComponent: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
