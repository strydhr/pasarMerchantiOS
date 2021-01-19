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
    func realtimeOrderUpdate(requestComplete:@escaping(_ orderList:[OrderDocument])->Void)->ListenerRegistration?{
        var orderList = [OrderDocument]()
        let todaysDate = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: todaysDate)
        let dbRef = db.collection("orders").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        return dbRef.addSnapshotListener { (snapshot, error) in
            if error == nil{
                guard let document = snapshot else {return}
                document.documentChanges.forEach { (diff) in
                    if(diff.type == .added){
                        let order = try! FirestoreDecoder().decode(Order.self, from: diff.document.data())
                        let orderDoc = OrderDocument(documentId: diff.document.documentID, order: order)
                        if order.hasDeliveryTime{
                            if order.date.dateValue() > startOfDay{
                            orderList.append(orderDoc)
                            }
                        }else{
                            orderList.append(orderDoc)
                        }
                        
                    }
//                    if(diff.type == .modified){
//                        let neworder = try! FirestoreDecoder().decode(Order.self, from: diff.document.data())
//                        if let modifiedOrderIndex = orderList.firstIndex(where: {$0.documentId == diff.document.documentID}){
//                            orderList[modifiedOrderIndex].order = neworder
//                        }
//
//                    }
                    print("new order")
                    requestComplete(orderList)
                }
            }
        }
        
    }
    

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
        
        let dbRef = db.collection("receipt").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("caseClosed", isEqualTo: false)
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
    func confirmReadyOrder(order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).updateData(["confirmationStatus":2,"hasDelivered":true]) { (error) in
            if error == nil{
                let receipt = Receipts(items: order.order!.items, date: order.order!.date, hasDeliveryTime: order.order!.hasDeliveryTime, deliveryTime: order.order!.deliveryTime, purchaserId: order.order!.purchaserId, purchaserName: order.order!.purchaserName, purchaserAddress: order.order!.purchaserAddress, purchaserPhone: order.order!.purchaserPhone, purchaserDeviceToken: order.order!.purchaserDeviceToken, storeId: order.order!.storeId, storeName: order.order!.storeName, ownerId: order.order!.ownerId, hasDelivered: order.order!.hasDelivered, caseClosed: false, orderId: order.documentId!)
                let docData = try! FirestoreEncoder().encode(receipt)
                
                db.collection("receipt").addDocument(data: docData) { (error) in
                    if error == nil{
                        requestComplete(true)
                    }
                }
            }
        }
    }
    
    func confirmStockOrder(order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).updateData(["confirmationStatus":2,"hasDelivered":true]) { (error) in
            if error == nil{
                let receipt = Receipts(items: order.order!.items, date: order.order!.date, hasDeliveryTime: order.order!.hasDeliveryTime, deliveryTime: order.order!.deliveryTime, purchaserId: order.order!.purchaserId, purchaserName: order.order!.purchaserName, purchaserAddress: order.order!.purchaserAddress, purchaserPhone: order.order!.purchaserPhone, purchaserDeviceToken: order.order!.purchaserDeviceToken, storeId: order.order!.storeId, storeName: order.order!.storeName, ownerId: order.order!.ownerId, hasDelivered: order.order!.hasDelivered, caseClosed: false, orderId: order.documentId!)
                let docData = try! FirestoreEncoder().encode(receipt)
                
                db.collection("receipt").addDocument(data: docData) { (error) in
                    if error == nil{
                        
                        requestComplete(true)
                    }
                }
            }
        }
    }
//    func updateStock(productList:[ProductDocument],order:OrderDocument) ->(Bool,[ProductDocument]){
    func updateStock(productList:[ProductDocument],order:OrderDocument,requestComplete:@escaping(_ status:Bool,_ newProductList:[ProductDocument])->()){
        let products = order.order?.items
        
        for item in products!{
            let product = productList.filter({$0.documentId == item.productId}).first
            print(product?.product?.count)
            print(item.itemCount)
            let newCount = (product?.product!.count)! - item.itemCount
            print(newCount)
            print(item.productId)
            db.collection("product").document(item.productId).updateData(["count":newCount])
            productList.filter({$0.documentId == item.productId}).first?.product?.count = newCount
        }
        
        requestComplete(true,productList)
    }
    func isStockEnough(productList:[ProductDocument],order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        let products = order.order?.items
        var status = true
        
        for item in products!{
           let product = productList.filter({$0.documentId == item.productId}).first
            if item.itemCount > (product?.product!.count)!{
                status = false
            }
        }
        
        if status == false{
            requestComplete(false)
        }else{
            requestComplete(true)
        }
    }
    
    
    
    func rejectOrder(rejectionComments:String,order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).updateData(["confirmationStatus":0,"comment":rejectionComments,"hasDelivered":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func orderHaveBeenDelivered(receipt:ReceiptDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("receipt").document(receipt.documentId!).updateData(["hasDelivered":true,"caseClosed":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
}
