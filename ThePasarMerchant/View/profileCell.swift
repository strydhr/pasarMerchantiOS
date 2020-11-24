//
//  profileCell.swift
//  ThePasar
//
//  Created by Satyia Anand on 28/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol editProfileDetailsDelegate {
    func editDetails(user:Merchant)
}
protocol logoutDelegate {
    func logout()
}

class profileCell: UITableViewCell {
    @IBOutlet weak var outterCellView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var editBtn: UIImageView!
    
    var delegate:editProfileDetailsDelegate?
    var delegate2:logoutDelegate?
    
    var usingLogout = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        editBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editBtnPressed)))
        editBtn.isUserInteractionEnabled = true
        
    }
    
    @objc func editBtnPressed(){
        if usingLogout{
            delegate2?.logout()
        }else{
        delegate?.editDetails(user: userGlobal!)
        }
    }
    
    @objc func loggingOut(){
        delegate2?.logout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
