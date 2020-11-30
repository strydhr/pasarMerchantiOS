//
//  PasswordResetVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 25/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class PasswordResetVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    var btmHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
    }
    
    @objc func bgTapped(){
        view.endEditing(true)
    }

    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        errorHandler(email: emailTF.text!)
    }
    
}
extension PasswordResetVC{
    func initLayout(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        let phoneHeight = UIScreen.main.bounds.size.height
        btmHeight = (phoneHeight - 520) / 2
        bottomHeight.constant = btmHeight! + 125
        
        emailTF.layer.cornerRadius = 17
        emailTF.layer.masksToBounds = true
        emailTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        emailTF.layer.borderWidth = 3
        emailTF.attributedPlaceholder = NSAttributedString(string: "Your Email", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        
    }
    
    func errorHandler(email:String){
        proceedBtn.isEnabled = false
        if (email.isEmpty){
            //Alert
            let alert = UIAlertController(title: "Error", message: "Email is empty.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            AuthServices.instance.resetPassword(email: email) { (isSuccess, error) in
                if isSuccess{
                    let alert = UIAlertController(title: "New Password link Sent", message: "An url link have been sent to the email given", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }else{
                    _ = self.handleError(error!)
                    print(error!.localizedDescription)
                }
                
            }
        }
    }
}
