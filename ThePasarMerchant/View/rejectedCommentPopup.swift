//
//  rejectedCommentPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 18/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class rejectedCommentPopup: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var order:Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comments.text = order?.comment
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
    }


    @objc func dismissPopup(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendBtnPressed(_ sender: UIButton) {
    }
}
