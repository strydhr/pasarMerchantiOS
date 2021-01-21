//
//  salesItemCell.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 21/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class salesItemCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item:itemPurchasing){
        self.productName.text = item.productName
        let unitPrice = item.productPrice
        self.unitPrice.text = "(unit price - RM\(String(format: "%.2f", unitPrice)))"
        self.count.text = "\(item.itemCount)"
        let total = unitPrice * Double(item.itemCount)
        self.totalPrice.text = "RM \(String(format: "%.2f", total))"
    }
    
}
