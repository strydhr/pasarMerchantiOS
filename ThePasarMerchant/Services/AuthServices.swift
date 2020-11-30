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
    
    func resetPassword(email:String,requestComplete:@escaping(_ status:Bool,_ error: Error?)->()){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
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
    
    func registerDeviceToken(){
        InstanceID.instanceID().instanceID { (result, error) in
            if error == nil{
                let token = result?.token
                    db.collection("Merchant").document(Auth.auth().currentUser!.uid).updateData(["deviceToken":token!])
                
            }
        }
    }
    
    func updateDeviceToken(){
        InstanceID.instanceID().instanceID { (result, error) in
            if error == nil{
                let token = result?.token
                    db.collection("Merchant").document(Auth.auth().currentUser!.uid).updateData(["deviceToken":token!])
                    let dbRef = db.collection("store").whereField("ownerId", isEqualTo: Auth.auth().currentUser?.uid)
                    dbRef.getDocuments { (snapshot, error) in
                        if error == nil{
                            guard let document = snapshot?.documents else {return}
                            for item in document{
                                db.collection("store").document(item.documentID).updateData(["deviceToken":token!])
                            }
                        }
                    }
                    
                
                
                
            }
        }
        
    }
    
 //Test
//    func test(){
//        let token = "d5dqSXadkTY:APA91bE2T8K3pfuwT19Qul_6o7AKCrwnPvmg0eU-iUPEevtZ7ng3-6qHBwfMF9S7h3EH-JOPxgYz3OgrdDuDSWSoKlPBCSpktv_P0q1fjI7YK_pr-Mv3TnI7TOkY6-f2jEPa28kBqqot"
//        let dbRef = db.collection("receipt")
//        dbRef.getDocuments { (snapshot, error) in
//            if error == nil{
//                guard let document = snapshot?.documents else {return}
//                for item in document{
//                    db.collection("receipt").document(item.documentID).updateData(["purchaserDeviceToken":token])
//                }
//            }
//        }
//    }
}


