//
//  bottomComponent.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 19/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class bottomComponent: UITableViewCell {
    @IBOutlet weak var complaintComment: UILabel!
    @IBOutlet weak var resolveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func resolveBtnPressed(_ sender: UIButton) {
    }
    
}
