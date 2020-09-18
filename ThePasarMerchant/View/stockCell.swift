//
//  stockCell.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 15/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol StockDelegate {
    func increaseStock(product:ProductDocument)
    func decreaseStock(product:ProductDocument)
}


class stockCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var product:ProductDocument?
    var delegate: StockDelegate?
//    var delegate2: decreaseStockDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func minusBtnPressed(_ sender: UIButton) {
        delegate?.decreaseStock(product: product!)
    }
    @IBAction func addBtnPressed(_ sender: UIButton) {
        delegate?.increaseStock(product: product!)
    }
    
}
