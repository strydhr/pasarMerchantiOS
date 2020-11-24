//
//  RegisterStoreVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 27/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseAuth
import SVProgressHUD

protocol hasStoreDelegate {
    func hasStore(status:Bool)
}

class RegisterStoreVC: UIViewController {
    @IBOutlet weak var editTable: UITableView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var delegate:hasStoreDelegate?
    var fromMain = true
    
    var isEdit = false
    var store:StoreDocument?
    var newEditImage = false
    var imageName = ""
    
    let typePicker = UIPickerView()
    let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector (donePicking))
    let category = ["Meals","Pastry","Dessert","Handmade","Second Hands"]
    let nameIndexPath:IndexPath = [0,0]
    let typeIndexPath:IndexPath = [0,1]
    let locationIndexPath:IndexPath = [0,2]
    let imageIndexPath:IndexPath = [0,3]
    
    var address:String?
    var gmsFetcher: GMSAutocompleteFetcher!
    var resultAC = [GMSAutocompletePrediction]()
    let placeClient = GMSPlacesClient()
    var latitude:Double?
    var longitude:Double?
    var geoHash:String?
    
    var selectedImage: UIImage?
    var isStoreImageSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        editTable.delegate = self
        editTable.dataSource = self
        editTable.separatorStyle = .none
        editTable.register(UINib(nibName: "registerStoreCell", bundle: nil), forCellReuseIdentifier: "registerStoreCell")
        editTable.register(UINib(nibName: "registerStoreImageCell", bundle: nil), forCellReuseIdentifier: "registerStoreImageCell")
        typePicker.delegate = self
        typePicker.dataSource = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
    }
    
    @objc func bgTapped(){
        let cell = editTable.cellForRow(at: nameIndexPath) as! registerStoreCell
        cell.editTF.resignFirstResponder()
    }
    
    @objc func donePicking(){
        let cell = editTable.cellForRow(at: typeIndexPath) as! registerStoreCell
        cell.editTF.resignFirstResponder()
        
    }
        @objc func addAddress(){
    //        searchView.isHidden = false
    //        searchbar.delegate = self
    //        resultTable.delegate = self
    //        resultTable.dataSource = self
    //
    //        let filter = GMSAutocompleteFilter()
    //        filter.country = Locale.current.regionCode
    //        gmsFetcher = GMSAutocompleteFetcher()
    //        gmsFetcher.autocompleteFilter = filter
    //        self.gmsFetcher.delegate = self
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self

            let fields:GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | GMSPlaceField.addressComponents.rawValue | GMSPlaceField.formattedAddress.rawValue)!
            autocompleteController.placeFields = fields

            let filter = GMSAutocompleteFilter()
            filter.country = "MY"
//            filter.type = .address
            autocompleteController.autocompleteFilter = filter

            present(autocompleteController, animated: true, completion: nil)
            
        }

    @objc func  imageTapped(){
        let alert = UIAlertController(title: "Add Store Image", message: "Please Select an Option", preferredStyle: .actionSheet)
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
        let storeName = editTable.cellForRow(at: nameIndexPath) as! registerStoreCell
        let type = editTable.cellForRow(at: typeIndexPath) as! registerStoreCell
        let location = editTable.cellForRow(at: locationIndexPath) as! registerStoreCell
        errorHandler(storeName: storeName.editTF.text!, type: type.editTF.text!, location: location.editTF.text!)
    }
}

extension RegisterStoreVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3{
            return 180
        }else{
        return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "registerStoreCell")as? registerStoreCell else {return UITableViewCell()}
        guard let cellb = tableView.dequeueReusableCell(withIdentifier: "registerStoreImageCell")as? registerStoreImageCell else {return UITableViewCell()}
        
        if isEdit{
            switch indexPath.row {
            case 0:
                cell.editTF.text = store?.store?.name
                cell.editTF.autocapitalizationType = .words
                return cell
            case 1:
                cell.editTF.text = store?.store?.type
                //
                
                typePicker.showsSelectionIndicator = true
                cell.editTF.inputView = typePicker
                
                
                let newToolbar = UIToolbar()
                newToolbar.sizeToFit()
                
                
                newToolbar.setItems([doneBtn], animated: false)
                newToolbar.isUserInteractionEnabled = true
                cell.editTF.inputAccessoryView = newToolbar
                return cell
                //
            case 2:
                cell.editTF.text = store?.store?.location
                cell.editTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAddress)))
                return cell
            default:
                cellb.storeImage.cacheImage(imageUrl: (store?.store!.profileImage)!)
                cellb.storeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
                cellb.storeImage.isUserInteractionEnabled = true
                return cellb
                
            }
        }else{
            switch indexPath.row {
            case 0:
                cell.editTF.attributedPlaceholder = NSAttributedString(string: "Name")
                cell.editTF.autocapitalizationType = .words
                return cell
            case 1:
                cell.editTF.attributedPlaceholder = NSAttributedString(string: "Type")
                //
                
                typePicker.showsSelectionIndicator = true
                cell.editTF.inputView = typePicker
                
                
                let newToolbar = UIToolbar()
                newToolbar.sizeToFit()
                
                
                newToolbar.setItems([doneBtn], animated: false)
                newToolbar.isUserInteractionEnabled = true
                cell.editTF.inputAccessoryView = newToolbar
                return cell
                //
            case 2:
                cell.editTF.attributedPlaceholder = NSAttributedString(string: "Location")
                cell.editTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAddress)))
                return cell
            default:
                cellb.storeImage.image = UIImage(named: "defaultImg")
                cellb.storeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
                cellb.storeImage.isUserInteractionEnabled = true
                return cellb
                
            }
        }
        
        
        
    }
    
    
}

extension RegisterStoreVC:UIPickerViewDelegate,UIPickerViewDataSource{
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
        let cell = editTable.cellForRow(at: typeIndexPath) as! registerStoreCell
        cell.editTF.text = category[row]

       }
    
    
}

extension RegisterStoreVC:GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let locationCell = editTable.cellForRow(at: locationIndexPath) as! registerStoreCell
        locationCell.editTF.text = place.name
        address = place.formattedAddress
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        geoHash = place.coordinate.geohash(length: 10)
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterStoreVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let editedImage = info[.editedImage]{
            selectedImage = (editedImage as! UIImage)
        }else if let originalImage = info[.originalImage]{
            selectedImage = (originalImage as! UIImage)
        }
        let storeImage = editTable.cellForRow(at: imageIndexPath) as! registerStoreImageCell
        storeImage.storeImage.image = selectedImage
            isStoreImageSet = true
        if isEdit{
            newEditImage = true
        }
  

        dismiss(animated: true, completion: nil)
        
    }
    

}

extension RegisterStoreVC{
    func loadDatas(){
        if isEdit{
            isStoreImageSet = true
            imageName = splitUrl()
        }
        
    }
    func errorHandler(storeName:String,type:String,location:String){
        if(storeName.isEmpty || type.isEmpty || location.isEmpty){
            if(storeName.isEmpty){
                
                //Alert
                let alert = UIAlertController(title: "Error", message: "Store name is empty.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            if(type.isEmpty){
                
                //Alert
                let alert = UIAlertController(title: "Error", message: "Store type is empty", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            if(location.isEmpty){
                //Alert
                let alert = UIAlertController(title: "Error", message: "Store location is empty", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            if !isStoreImageSet{
                //Alert
                let alert = UIAlertController(title: "Error", message: "Store image have not been uploaded", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                confirmBtn.isEnabled = false
                if isEdit{
                    if newEditImage{
                        
                        uploadEditedImage(image: selectedImage!, imageName: imageName) { (imageurl) in
                            self.store?.store?.profileImage = imageurl
                            self.store?.store?.name = storeName
                            self.store?.store?.type = type
                            self.store?.store?.location = location
                            self.store?.store?.l[0] = self.latitude!
                            self.store?.store?.l[1] = self.longitude!
                            self.store?.store?.g = self.geoHash!
                            StoreServices.instance.editStorestore(store: self.store!) { (isSuccess) in
                                if isSuccess{
                                    self.delegate?.hasStore(status: true)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }
                    }else{
                        self.store?.store?.name = storeName
                        self.store?.store?.type = type
                        self.store?.store?.location = location
                        if self.latitude != nil{
                        self.store?.store?.l[0] = self.latitude!
                        self.store?.store?.l[1] = self.longitude!
                        self.store?.store?.g = self.geoHash!
                        }
                        StoreServices.instance.editStorestore(store: self.store!) { (isSuccess) in
                            if isSuccess{
                                self.delegate?.hasStore(status: true)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }else{
                    uploadImages(image: selectedImage!) { (imageurl) in
                        let uid = autoID(length: 28)
                        let date = Timestamp()
                        let store = Store(uid: uid, name: storeName, type: type, location: location, lat: self.latitude!, lng: self.longitude!, g: self.geoHash!, startDate: date, ownerId: userGlobal!.uid, profileImage: imageurl, isEnabled: true, deviceToken: "1")
                        StoreServices.instance.addStore(store: store) { (isSuccess) in
                            if isSuccess{
                                AuthServices.instance.updateStoreCount(merchant: userGlobal!) { (isUpdated) in
                                    if isUpdated{
                                        userGlobal!.storeCount = userGlobal!.storeCount + 1
                                        if self.fromMain{
                                            
                                        }else{
                                            let storeDoc = StoreDocument(documentId: uid, store: store)
                                            userGlobalStores.append(storeDoc)
                                        }
                                        self.delegate?.hasStore(status: true)
                                        self.navigationController?.popViewController(animated: true)
    //                                    userStores.append(store)
                                        
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
                

            }
        }
    }
    
    func uploadImages(image: UIImage,requestURL: @escaping(_ url:String)->()){
//        let imageName = autoID(length: 28)
        let imageName = "Store\((userGlobal?.storeCount)!)"
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
    func uploadEditedImage(image: UIImage,imageName: String,requestURL: @escaping(_ url:String)->()){
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
    func splitUrl()->String{
        var url = store?.store?.profileImage
        var unwantedStr = "https://firebasestorage.googleapis.com/v0/b/thepasar-c78f6.appspot.com/o/UsersFiles%2F" + userGlobal!.uid + "%2FStore%2F"

        let newStr = url?.slice(from: unwantedStr, to: "?alt")

        return newStr!
    }
}
extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
