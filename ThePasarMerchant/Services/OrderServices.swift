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
    
//    func realtimeListUpdate(requestComplete:@escaping(_ orderList:[Receipts])->()){
//                var orderList = [Receipts]()
//
//        let dbRef = db.collection("receipts").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
//        dbRef.addSnapshotListener { (snapshot, error) in
//             if error == nil{
//                           guard let document = snapshot?.documents else {return}
//                           if document.isEmpty{
//                               requestComplete(orderList)
//                           }else{
//                               for items in document{
//                                   let docData = items.data()
//                                   print(docData)
//                                   let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
//                                   orderList.append(receipts)
//
//
//                               }
//                               requestComplete(orderList)
//
//                           }
//                       }
//        }
//
//    }
    func realtimeOrderListUpdate(requestComplete:@escaping(_ orderList:[OrderDocument])->()){
        var orderList = [OrderDocument]()
        let todaysDate = Date()
        let calendar = Calendar.current
        
        let dbRef = db.collection("orders").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        dbRef.addSnapshotListener { (snapshot, error) in
            if error == nil{
                guard let document = snapshot else {return}
                document.documentChanges.forEach { (diff) in
                    if(diff.type == .added){
                        let order = try! FirestoreDecoder().decode(Order.self, from: diff.document.data())
                        let orderDoc = OrderDocument(documentId: diff.document.documentID, order: order)
                        orderList.append(orderDoc)
                    }
                    requestComplete(orderList)
                }
            }
        }
        
    }
    func realtimeReceiptListUpdate(requestComplete:@escaping(_ orderList:[ReceiptDocument])->()){
        var orderList = [ReceiptDocument]()
        let todaysDate = Date()
        let calendar = Calendar.current
        
        let dbRef = db.collection("receipt").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        dbRef.addSnapshotListener { (snapshot, error) in
            if error == nil{
                guard let document = snapshot else {return}
                document.documentChanges.forEach { (diff) in
                    if(diff.type == .added){
                        let order = try! FirestoreDecoder().decode(Receipts.self, from: diff.document.data())
                        let orderDoc = ReceiptDocument(documentId: diff.document.documentID, order: order)
                        orderList.append(orderDoc)
                    }
                    requestComplete(orderList)
                }
            }
        }
        
    }
    func confirmOrder(order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).updateData(["confirmationStatus":2,"hasDelivered":true]) { (error) in
            if error == nil{
                let receipt = Receipts(items: order.order!.items, date: order.order!.date, hasDeliveryTime: order.order!.hasDeliveryTime, deliveryTime: order.order!.deliveryTime, purchaserId: order.order!.purchaserId, purchaserName: order.order!.purchaserName, purchaserAddress: order.order!.purchaserAddress, storeId: order.order!.storeId, storeName: order.order!.storeName, ownerId: order.order!.ownerId, hasDelivered: order.order!.hasDelivered)
                let docData = try! FirestoreEncoder().encode(receipt)
                
                db.collection("receipt").addDocument(data: docData) { (error) in
                    if error == nil{
                        requestComplete(true)
                    }
                }
            }
        }
    }
    
    
    
    func rejectOrder(rejectionComments:String,order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).updateData(["confirmationStatus":1,"comment":rejectionComments,"hasDelivered":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func orderHaveBeenDelivered(receipt:ReceiptDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("receipt").document(receipt.documentId!).updateData(["hasDelivered":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
}
