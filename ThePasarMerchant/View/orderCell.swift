//
//  orderCell.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class orderCell: UITableViewCell {
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
    
    var isResolved:Bool?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(){
        tickIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resolveComplaint)))
        tickIcon.isUserInteractionEnabled = true
    }
    @objc func resolveComplaint(){
        if isResolved!{
            
        }else{
            tickIcon.image = UIImage(named: "tickicon")
        }
        
    }
    
}
