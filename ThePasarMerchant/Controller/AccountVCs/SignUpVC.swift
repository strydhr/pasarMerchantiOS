//
//  SignUpVC.swift
//  HomePlus
//
//  Created by Satyia Anand on 20/02/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//  

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var createAccLabel: UILabel!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confrimPwTF: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var termBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var btmHeight:CGFloat?
    
    var fullname:String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
    
        
//        //Inits
        initLayout()
        setupLabel()
//
//        usernameTF.delegate = self
//        emailTF.delegate = self
//        passwordTF.delegate = self
//        confrimPwTF.delegate = self
        
        //Keyboard
        let phoneHeight = UIScreen.main.bounds.size.height
        btmHeight = (phoneHeight - 520) / 2
        bottomConstraint.constant = btmHeight!
        
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
                
                self.bottomConstraint?.constant = btmHeight!
                
                
                //
                //keyboardViewOpen = false
            }else{
                
                self.bottomConstraint?.constant = (endFrame?.size.height)! - 30
                
                
                //keyboardViewOpen = true
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupProfileImageSegue"{
            let destination = segue.destination as! SignupProfileImageVC
            destination.fullname = fullname


        }
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        errorHandler(username: usernameTF.text!, email: emailTF.text!, password: passwordTF.text!, confirmPassword: confrimPwTF.text!)
    }
    @IBAction func termBtnPressed(_ sender: UIButton) {
        let urlWhats = "https://aohome675642161.wordpress.com/terms-and-conditions/"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
            }
        }
    }
    @IBAction func privacyBtnPressed(_ sender: UIButton) {
        let urlWhats = "https://aohome675642161.wordpress.com/privacy-policy/"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
            }
        }
    }
}

extension SignUpVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == usernameTF){
            self.usernameTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else if(textField == emailTF){
            self.emailTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else if(textField == passwordTF){
            passwordTF.isSecureTextEntry = true
            passwordTF.text = ""
            self.passwordTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else if(textField == confrimPwTF){
            confrimPwTF.isSecureTextEntry = true
            confrimPwTF.text = ""
            self.confrimPwTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }

    }
}


extension SignUpVC{
    func initLayout(){
        usernameTF.autocapitalizationType = .words
        usernameTF.layer.cornerRadius = 17
        usernameTF.layer.masksToBounds = true
        usernameTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        usernameTF.layer.borderWidth = 3
        usernameTF.attributedPlaceholder = NSAttributedString(string: "Your Full Name", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])

        emailTF.layer.cornerRadius = 17
        emailTF.layer.masksToBounds = true
        emailTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        emailTF.layer.borderWidth = 3
        emailTF.attributedPlaceholder = NSAttributedString(string: "Your Email", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])

        passwordTF.layer.cornerRadius = 17
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        passwordTF.layer.borderWidth = 3
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])

        confrimPwTF.layer.cornerRadius = 17
        confrimPwTF.layer.masksToBounds = true
        confrimPwTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        confrimPwTF.layer.borderWidth = 3
        confrimPwTF.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }

    func errorHandler(username:String,email:String,password:String,confirmPassword:String){
        if(username.isEmpty || username == "Empty Field" || email.isEmpty || email == "Invalid Email" || password.isEmpty || password == "Empty Field" || confirmPassword.isEmpty || confirmPassword == "Password entered is different" ){
            if(username.isEmpty){
                self.usernameTF.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                //Alert
                let alert = UIAlertController(title: "Error", message: "Username empty.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)


            }
            if(confirmPassword.isEmpty){
                self.confrimPwTF.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                //Alert
                let alert = UIAlertController(title: "Error", message: "Confirm password is not the same as password.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }

            if(confirmPassword != password){
                self.confrimPwTF.isSecureTextEntry = false
                self.confrimPwTF.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                //Alert
                let alert = UIAlertController(title: "Error", message: "Confirm password is not the same as password.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }

        }else{
            print("DONE")
            self.fullname = username
            AuthServices.instance.registerNewUser(email: emailTF.text!, password: confrimPwTF.text!) { (isSuccess, error) in
                if isSuccess{
                    self.performSegue(withIdentifier: "signupProfileImageSegue", sender: self)
                }else{
                    _ = self.handleError(error!)
                    print(error!.localizedDescription)
                    if(error!.localizedDescription == "The email address is badly formatted."){
                        self.emailTF.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                    }else if(error!.localizedDescription == "An email address must be provided."){
                        self.emailTF.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                    }else if(error!.localizedDescription == "The password must be 6 characters long or more."){
                        self.passwordTF.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                    }
                }
            }


        }
    }


    func setupLabel(){
        let longString = "CREATE ACCOUNT"
        let longestWord = "ACCOUNT"

        let longestWordRange = (longString as NSString).range(of: longestWord)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])

        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)], range: longestWordRange)


        createAccLabel.attributedText = attributedString
    }

}


extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .missingEmail:
            return "An email address must be provided"
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
//            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)


            self.present(alert, animated: true, completion: nil)

        }
    }

}
