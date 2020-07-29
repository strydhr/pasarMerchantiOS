//
//  addProductPopup.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseAuth
import SVProgressHUD

protocol updateProductsDelegate{
    func reloadTable()
}

class addProductPopup: UIViewController {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var detailsTF: UITextView!
    
    var delegate:updateProductsDelegate?
    
    var store:Store?
    var isProductImageSet = false
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        image.isUserInteractionEnabled = true
        
        nameTF.autocapitalizationType = .words
        detailsTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        detailsTF.layer.borderWidth = 1
        
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(softkeyboarddown)))
    }
    @objc func softkeyboarddown(){
        nameTF.resignFirstResponder()
        priceTF.resignFirstResponder()
        detailsTF.resignFirstResponder()
        
    }
    
    @objc func  imageTapped(){
        let alert = UIAlertController(title: "Add Product Image", message: "Please Select an Option", preferredStyle: .actionSheet)
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

    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        errorHandler(productName: nameTF.text!, productPrice: priceTF.text!,productDetails: detailsTF.text!)
    }

}
extension addProductPopup:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let editedImage = info[.editedImage]{
            selectedImage = (editedImage as! UIImage)
        }else if let originalImage = info[.originalImage]{
            selectedImage = (originalImage as! UIImage)
        }
        image.image = selectedImage
        isProductImageSet = true
        
  

        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImages(image: UIImage,imageName: String,requestURL: @escaping(_ url:String)->()){
        let storage = Storage.storage()
        let storageRef = storage.reference().child("UsersFiles").child((Auth.auth().currentUser?.uid)!).child("Store")
        
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
extension addProductPopup{
    func errorHandler(productName:String,productPrice:String,productDetails:String){
        if(productName.isEmpty || productPrice.isEmpty || productDetails.isEmpty){
            if(productName.isEmpty){
                
                //Alert
                let alert = UIAlertController(title: "Error", message: "Product name is empty.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            if(productPrice.isEmpty){
                
                //Alert
                let alert = UIAlertController(title: "Error", message: "Product price is empty", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            if(productDetails.isEmpty){
                
                //Alert
                let alert = UIAlertController(title: "Error", message: "Product details is empty", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            if !isProductImageSet{
                //Alert
                let alert = UIAlertController(title: "Error", message: "Store image have not been uploaded", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                confirmBtn.isEnabled = false
                let uid = autoID(length: 28)
                let productPricing = Double(productPrice)
                uploadImages(image: selectedImage!, imageName: uid) { (imageurl) in
                    let product = Product(uid: uid, name: productName, type: self.store!.type, details: productDetails, sid: self.store!.uid, count: 0, price: productPricing!, availability: true, profileImage: imageurl, hasCounter: false)
                    StoreServices.instance.addItem(item: product) { (isSuccess) in
                        if isSuccess{
                            self.delegate?.reloadTable()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
