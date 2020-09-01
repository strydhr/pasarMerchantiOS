//
//  AuthServices.swift
//  HomePlus
//
//  Created by Satyia Anand on 20/02/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

let db = Firestore.firestore()

class AuthServices {
    static let instance = AuthServices()
    
    func registerNewUser(email:String,password:String,requestComplete:@escaping(_ status: Bool,_ error: Error?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil{
                requestComplete(true,nil)
            }else{
                requestComplete(false,error!)
            }
        }
    }
    func addUserToDatabase(name:String,address:String,profileImage:String,requestComplete:@escaping(_ status: Bool)->()){
        
        let user = Merchant(uid: Auth.auth().currentUser!.uid, name: name, phone: "", address: address, accType: "Merchant", storeCount: 0, profileImage: profileImage, isActivated: true, isActive: true, registeredDate: Timestamp(date: Date()))
        userGlobal = user
        
        let docData = try! FirestoreEncoder().encode(user)
        
        db.collection("Merchant").document((Auth.auth().currentUser?.uid)!).setData(docData, completion: { (err) in
            if let error = err{
                print("Error Adding New User:\(error)")
            }else{
               requestComplete(true)
                
                
            }
        })
    }
     func loginUser(withEmail email: String,andPassword password: String,requestComplete: @escaping(_ status: Bool,_ error: Error?)->()){
    
    
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    requestComplete(true,nil)
                }else{
                    requestComplete(false,error!)
                }
            }
    
    
        }
    func updateStoreCount(merchant:Merchant,requestComplete: @escaping(_ status: Bool)->()){
        db.collection("Merchant").document(merchant.uid).updateData(["storeCount":merchant.storeCount + 1]) { (err) in
            if err == nil{
                requestComplete(true)
            }
        }
    }
    
//    func registerNewUser(email:String,password:String,requestComplete:@escaping(_ status: Bool,_ error: Error?)->()){
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            if error == nil{
//                requestComplete(true,nil)
//            }else{
//                requestComplete(false,error!)
//            }
//        }
//    }
//    

//    
//    func loginUser(withEmail email: String,andPassword password: String,requestComplete: @escaping(_ status: Bool,_ error: Error?)->()){
//        
//        
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            if error == nil{
//                requestComplete(true,nil)
//            }else{
//                print(error)
//                requestComplete(false,error!)
//            }
//        }
//        
//        
//    }
//    
//    func resetPassword(email:String,requestComplete:@escaping(_ status:Bool,_ error: Error?)->()){
//        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
//            if error == nil{
//                requestComplete(true,nil)
//            }else{
//                requestComplete(false,error!)
//            }
//        }
//    }
//    
//    
//    func updateProfileDetails(user:LandLord,requestComplete:@escaping(_ status:Bool)->()){
//        db.collection(user.type).document(user.uid).updateData(["address":user.address,"bankAcc":user.bankAcc,"name":user.name,"phone":user.phone,"profileImage":user.profileImage]) { (error) in
//            if error == nil{
//                requestComplete(true)
//                
//            }
//        }
//    }
//    
//    func getAdminsDeviceToken(){
//        let adminInfo = db.collection("admin").document("4xFM4PFLLNfU7DS25j8A2ukm4MJ2")
//        adminInfo.getDocument(completion: { (snapshot, error) in
//            if error == nil{
//                
//                guard let snapShot = snapshot?.data() else {return}
//                adminToken = try! FirestoreDecoder().decode(AdminDeviceToken.self, from: snapShot )
//                
//                }
//                
//                
//        })
//        
//    }
//    
//    // For LandLord
//    func applyForPremiumPackage(type:String,requestComplete:@escaping(_ status:Bool)->()){
//        let applicant = userMainId(userId: (userGlobal?.uid)!, userName: (userGlobal?.name)!)
//        let date = Timestamp()
//        
//        let application = ApplyForPremium(applicant: applicant, appliedDate: date, type: type)
//        let docData = try! FirestoreEncoder().encode(application)
//        db.collection("premium").document((userGlobal?.uid)!).setData(docData, completion: { (err) in
//            if err == nil{
//                requestComplete(true)
//            }else{
//                requestComplete(false)
//            }
//        })
//    }
//    
//    func getDeviceToken(accType:String){
//        InstanceID.instanceID().instanceID { (result, error) in
//            if error == nil{
//                let token = result?.token
//                db.collection(accType).document(Auth.auth().currentUser!.uid).updateData(["deviceToken":token!])
//            }
//        }
//    }
//    
//    func updateDeviceToken(accType:String){
//        InstanceID.instanceID().instanceID { (result, error) in
//            if error == nil{
//                let token = result?.token
//                if accType == "landlord"{
//                    db.collection(accType).document(Auth.auth().currentUser!.uid).updateData(["deviceToken":token!])
//                    let dbRef = db.collection("property").whereField("ownerId", isEqualTo: Auth.auth().currentUser?.uid)
//                    dbRef.getDocuments { (snapshot, error) in
//                        if error == nil{
//                            guard let document = snapshot?.documents else {return}
//                            for item in document{
//                                db.collection("property").document(item.documentID).updateData(["ownerDeviceToken":token!])
//                            }
//                        }
//                    }
//                    
//                }else{
//                    db.collection(accType).document(Auth.auth().currentUser!.uid).updateData(["deviceToken":token!])
//                }
//                
//                
//            }
//        }
//        
//    }
}


