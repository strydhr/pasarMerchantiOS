//
//  orderHeader.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol rejectOrderDelegate{
    func rejectOrder(item:Receipts)
}

class orderHeader: UITableViewCell {
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    
    var delegate: rejectOrderDelegate?
    var item: Receipts?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func rejectBtnPressed(_ sender: UIButton) {
        delegate?.rejectOrder(item: item!)
    }
    
}
