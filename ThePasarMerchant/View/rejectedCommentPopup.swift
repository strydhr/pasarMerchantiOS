//
//  rejectedCommentPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 18/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol removeRejectedOrderDelegate {
    func removeFromList(item:OrderDocument)
}

class rejectedCommentPopup: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var delegate:removeRejectedOrderDelegate?
    var order:OrderDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
    }


    @objc func dismissPopup(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        OrderServices.instance.rejectOrder(rejectionComments: comments.text, order: order!) { (isSuccess) in
            if isSuccess{
                self.delegate?.removeFromList(item: self.order!)
                self.dismissPopup()
            }
        }
    }
}
