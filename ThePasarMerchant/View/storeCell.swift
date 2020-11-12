//
//  storeCell.swift
//  ThePasar
//
//  Created by Satyia Anand on 29/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class storeCell: UITableViewCell {
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var storeType: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
