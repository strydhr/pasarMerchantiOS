//
//  orderHeader.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol rejectOrderDelegate{
    func rejectOrder(item:OrderDocument)
}
protocol confirmOrderDelegate{
    func confirmOrder(item:OrderDocument)
}

class orderHeader: UITableViewCell {
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var delegate: rejectOrderDelegate?
    var delegate2: confirmOrderDelegate?
    var item: OrderDocument?
    
    
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
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        delegate2?.confirmOrder(item: item!)
    }
    
}
