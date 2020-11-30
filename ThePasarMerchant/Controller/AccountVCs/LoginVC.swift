//
//  LoginVC.swift
//  HomePlus
//
//  Created by Satyia Anand on 19/02/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
// 


import UIKit
import Firebase
import CodableFirebase
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var overlayingView: UIView!
    @IBOutlet weak var introLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var loginBtn: RoundButton!

    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var btmConstraint: NSLayoutConstraint!
    var btmHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            fadeIn()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
        
        
        // Do any additional setup after loading the view.
        //navigationBar setup
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        
        let phoneHeight = UIScreen.main.bounds.size.height
        btmHeight = (phoneHeight - 400) / 2
        btmConstraint.constant = btmHeight!
        
//        initLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func bgTapped(){
        view.endEditing(true)
    }
    
    @objc func keyboardNotification(notification: NSNotification){
        if let userinfo = notification.userInfo {
            let endFrame = (userinfo[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration: TimeInterval = (userinfo[UIResponder.keyboardAnimationDurationUserInfoKey]as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userinfo[UIResponder.keyboardAnimationCurveUserInfoKey]as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                
                self.btmConstraint?.constant = btmHeight!
                
                
                //
                //keyboardViewOpen = false
            }else{
                
                self.btmConstraint?.constant = (endFrame?.size.height)! - 30
                
                
                //keyboardViewOpen = true
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        errorHandler(email: emailTF.text!, password: passwordTF.text!)
    }
    

    @IBAction func signupBtnPressed(_ sender: UIButton) {
    }
    
}

extension LoginVC{
    func fadeIn(){
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseIn, animations: {
            self.overlayingView.alpha = 0
        }, completion: nil)
    }
    
//    func initLayout(){
//
//        emailTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
//
//        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
//
//        _ = UILabel()
//        let navTitle = NSMutableAttributedString(string: "WELCOME TO ", attributes: [NSAttributedString.Key.font :UIFont(name: "Roboto-Light", size: 22.0)!,NSMutableAttributedString.Key.foregroundColor: UIColor.white])
//
//        navTitle.append(NSMutableAttributedString(string: "AO HOME", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Black", size: 22.0)!,NSMutableAttributedString.Key.foregroundColor: UIColor.white]))
//
//        introLbl.attributedText = navTitle
//
//        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
//        loginBtn.clipsToBounds = true
//    }
    
    func errorHandler(email:String,password:String){
        loginBtn.isEnabled = false
        if(email.isEmpty || email == "Invalid Email" || password.isEmpty || password == "Empty Field"){
            if(email.isEmpty){
                self.emailLineView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                //Alert
                let alert = UIAlertController(title: "Error", message: "Email is empty.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            if(password.isEmpty){
                self.passwordLineView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                //Alert
                let alert = UIAlertController(title: "Error", message: "Confirm password is not the same as password.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }

            loginBtn.isEnabled = true
        }else{
            AuthServices.instance.loginUser(withEmail: email, andPassword: password) { (isSuccess, error) in
                if isSuccess{
                    //
                    let userInfo = db.collection("Merchant").document((Auth.auth().currentUser?.uid)!)
                    userInfo.getDocument { (snapshot, err) in
                        if err == nil{
                            if snapshot!.exists{
                                guard let snapShot = snapshot?.data() else {return}
                                userGlobal = try! FirestoreDecoder().decode(Merchant.self, from: snapShot )
                                AuthServices.instance.updateDeviceToken()
                                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                let authVC = storyboard.instantiateViewController(withIdentifier: "loggedIn")
                                
                                authVC.modalPresentationStyle = .fullScreen
                                self.present(authVC, animated: true, completion: nil)
                            }else{
                                try! Auth.auth().signOut()
                            }
                            
                        }
                    }
                    //
                    
                }else{
                    self.loginBtn.isEnabled = true
                    _ = self.handleError(error!)
                    print(error!.localizedDescription)
                }
            }
        }
    }
}
