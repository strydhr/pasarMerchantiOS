//
//  SignupProfileImageVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 23/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class SignupProfileImageVC: UIViewController {
    @IBOutlet weak var userFullnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var proceedBtn: UIButton!
    
    var fullname:String?
    var selectedImage: UIImage?
    var isProfilePicSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        profileImage.isUserInteractionEnabled = true
    }
    

    @objc func  imageTapped(){
        let alert = UIAlertController(title: "Change Profile Image", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { (photoAlert) in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.delegate = self
            camera.allowsEditing = true
            self.present(camera, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (libraryAlert) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (libraryAlert) in
            print("Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        errorHandler()
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignupProfileImageVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let editedImage = info[.editedImage]{
            selectedImage = (editedImage as! UIImage)
        }else if let originalImage = info[.originalImage]{
            selectedImage = (originalImage as! UIImage)
        }
            self.profileImage.image = selectedImage
            isProfilePicSet = true
        
  

        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImages(image: UIImage,imageName: String,requestURL: @escaping(_ url:String)->()){
        let storage = Storage.storage()
        let storageRef = storage.reference().child("UsersFiles").child((Auth.auth().currentUser?.uid)!)
        
        if let uploaddata = image.jpegData(compressionQuality: 0.6){
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let uploadTask = storageRef.child(imageName).putData(uploaddata, metadata: metaData)
//            SVProgressHUD.show()
            _ = uploadTask.observe(.success) { (snapshot) in
                print(snapshot.status)
//                SVProgressHUD.dismiss()
                storageRef.child(imageName).downloadURL(completion: { (url, _) in
                    let urlString = url?.absoluteString
                    
                    requestURL(urlString!)
                    
                    
                })
                
                
                
            }
        }
    }
}


extension SignupProfileImageVC{
    func initLayout(){
        userFullnameLabel.text = "Hello \((fullname)!)"
        
    }
    
    func errorHandler(){
            if !isProfilePicSet{
                
            }else{
//                SVProgressHUD.show()
                uploadImages(image: profileImage.image!, imageName: "profile") { (url) in
                    AuthServices.instance.addUserToDatabase(name: self.fullname!, address: "", profileImage: url) { (isSuccess) in
                        if isSuccess{
//                            SVProgressHUD.dismiss()
                            let defaults = UserDefaults.standard
                            defaults.set(true, forKey: "isFirstTime")
                            //                        AuthServices.instance.updateDeviceToken(accType: accType!)

                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let authVC = storyboard.instantiateViewController(withIdentifier: "loggedIn")
                            authVC.modalPresentationStyle = .fullScreen
                            self.present(authVC, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        
    }
}
