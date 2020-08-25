//
//  receiptHeader.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 21/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
protocol completeOrderDelegate{
    func completeOrder(item:ReceiptDocument)
}

class receiptHeader: UITableViewCell {
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    
    var delegate: completeOrderDelegate?
    var item: ReceiptDocument?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func completeBtnPressed(_ sender: UIButton) {
        delegate?.completeOrder(item: item!)
    }
    
}
