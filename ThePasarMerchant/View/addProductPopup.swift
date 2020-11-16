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
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var countTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var detailsTF: UITextView!
    
    @IBOutlet weak var priceHeightConstraint: NSLayoutConstraint!
    var delegate:updateProductsDelegate?
    var currentTotalProduct:Int?
    
    var store:Store?
    let typePicker = UIPickerView()
    let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector (donePicking))
    let category = ["Meals","Pastry","Dessert","Handmade","Second Hands"]
    
    var isProductImageSet = false
    var selectedImage: UIImage?
    
    var stockCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        image.isUserInteractionEnabled = true
        
        nameTF.autocapitalizationType = .words
        detailsTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        detailsTF.layer.borderWidth = 1
        
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(softkeyboarddown)))
        
        initTextField()
        print(store?.ownerId)
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
    
    @objc func donePicking(){
        typeTF.resignFirstResponder()
        
    }

    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        errorHandler(productName: nameTF.text!, productPrice: priceTF.text!,productDetails: detailsTF.text!, productType: typeTF.text!)
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
    func errorHandler(productName:String,productPrice:String,productDetails:String,productType:String){
        if(productName.isEmpty || productPrice.isEmpty || productDetails.isEmpty || productType.isEmpty){
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
            if(productType.isEmpty){
                
                //Alert
                let alert = UIAlertController(title: "Error", message: "Product type is empty", preferredStyle: .alert)
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
                if  typeTF.text == "Homemade"{
                    stockCount = Int(String(countTF.text!))!
                }else{
                    stockCount = 0
                }
                
                let uid = autoID(length: 28)
                let productPricing = Double(productPrice)
                uploadImages(image: selectedImage!, imageName: uid) { (imageurl) in
                    let product = Product(uid: uid, name: productName, type: productType, details: productDetails, sid: self.store!.uid, count: self.stockCount, price: productPricing!, availability: true, profileImage: imageurl, hasCounter: false, colorClass: self.currentTotalProduct! + 1)
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
    
    func initTextField(){
        nameTF.placeholder = "Product Name"
        priceTF.placeholder = "Product Price"
        countTF.placeholder = "Stock Count"
        typePicker.delegate = self
        typePicker.dataSource = self
        typeTF.placeholder = "Type"
        detailsTF.text = "Product Detail"
        detailsTF.textColor = #colorLiteral(red: 0.8633741736, green: 0.8699255586, blue: 0.8700513244, alpha: 1)
        detailsTF.delegate = self
        createTypePicker()
        
        countTF.isHidden = true
        priceHeightConstraint.constant = 20
    }
    
    func createTypePicker(){
        typePicker.showsSelectionIndicator = true
        typeTF.inputView = typePicker
        
        let newToolbar = UIToolbar()
        newToolbar.sizeToFit()
        
        
        newToolbar.setItems([doneBtn], animated: false)
        newToolbar.isUserInteractionEnabled = true
        typeTF.inputAccessoryView = newToolbar
    }
}

extension addProductPopup:UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate{
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return category.count
           
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
               return category[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           doneBtn.isEnabled = true
        typeTF.text = category[row]
        
        if row == 3 {
            countTF.isHidden = false
            priceHeightConstraint.constant = 80
        }else{
            countTF.isHidden = true
            priceHeightConstraint.constant = 20
        }

       }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Product Detail"{
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    
}
