//
//  OrderServices.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 06/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class OrderServices {
    static let instance = OrderServices()
    
    
    func listMyOders(requestComplete:@escaping(_ orderList:[Receipts])->()){
        var orderList = [Receipts]()
        
        let dbRef = db.collection("receipts").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        dbRef.getDocuments { (snapshot, error) in
            print(snapshot?.count)
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(orderList)
                }else{
                    for items in document{
                        let docData = items.data()
                        print(docData)
                        let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
                        orderList.append(receipts)

                        
                    }
                    requestComplete(orderList)
                    
                }
            }
        
        }
    }
    
    func realtimeListUpdate(requestComplete:@escaping(_ orderList:[Receipts])->()){
                var orderList = [Receipts]()
        
        let dbRef = db.collection("receipts").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        dbRef.addSnapshotListener { (snapshot, error) in
             if error == nil{
                           guard let document = snapshot?.documents else {return}
                           if document.isEmpty{
                               requestComplete(orderList)
                           }else{
                               for items in document{
                                   let docData = items.data()
                                   print(docData)
                                   let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
                                   orderList.append(receipts)

                                   
                               }
                               requestComplete(orderList)
                               
                           }
                       }
        }
    
    }
    func realtimeListUpdate2(requestComplete:@escaping(_ orderList:[Receipts])->()){
        var orderList = [Receipts]()
        
        let dbRef = db.collection("receipts").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        dbRef.addSnapshotListener { (snapshot, error) in
            if error == nil{
                guard let document = snapshot else {return}
                document.documentChanges.forEach { (diff) in
                    if(diff.type == .added){
                        let receipts = try! FirestoreDecoder().decode(Receipts.self, from: diff.document.data())
                        orderList.append(receipts)
                    }
                    requestComplete(orderList)
                }
//                if document.isEmpty{
//                    requestComplete(orderList)
//                }else{
//                    for items in document{
//                        let docData = items.data()
//                        print(docData)
//                        let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
//                        orderList.append(receipts)
//                        
//                        
//                    }
//                    requestComplete(orderList)
//                    
//                }
            }
        }
        
    }
}
