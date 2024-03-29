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
    func openWaze(item:ReceiptDocument)
    func phoneCustomer(item:ReceiptDocument)
    func itemizeSales(item:ReceiptDocument)
}

class receiptHeader: UITableViewCell, SlideButtonDelegate {

    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var slideBtn: MMSlidingButton!
    @IBOutlet weak var totalCost: UILabel!
    
    var delegate: completeOrderDelegate?
    var item: ReceiptDocument?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        slideBtn.delegate = self
        completeBtn.layer.cornerRadius = 20
        completeBtn.clipsToBounds = true
        
        deliveryAddress.isUserInteractionEnabled = true
        deliveryAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openWaze)))
        phoneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneMsgCustomer)))
        totalCost.isUserInteractionEnabled = true
        totalCost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openItemize)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func phoneMsgCustomer(){
        delegate?.phoneCustomer(item: item!)
    }
    
    @objc func openWaze(){
        delegate?.openWaze(item: item!)
    }
    @objc func openItemize(){
        delegate?.itemizeSales(item: item!)
    }
    
    @IBAction func completeBtnPressed(_ sender: UIButton) {
        delegate?.completeOrder(item: item!)
    }
    
    func buttonStatus(status: String, sender: MMSlidingButton) {
        print(status)
        if status == "Unlocked"{
            slideBtn.isUserInteractionEnabled = false
            slideBtn.isHidden = true
            completeBtn.isHidden = false
        }
    }
}
