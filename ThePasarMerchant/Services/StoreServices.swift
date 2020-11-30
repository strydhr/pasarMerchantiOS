//
//  StoreServices.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class StoreServices {
    static let instance = StoreServices()
    
    func addStore(
        store:Store,requestComplete:@escaping(_ status:Bool)->()){
        let docData = try! FirestoreEncoder().encode(store)
        
        db.collection("store").document(store.uid).setData(docData) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func editStorestore(
        store:StoreDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("store").document(store.documentId!).updateData(["name":store.store?.name,"location":store.store?.location,"profileImage":store.store?.profileImage,"type":store.store?.type,"l":[store.store?.l[0],store.store?.l[1]],"g":store.store?.g]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
        
    }
    func closeStore(
        store:Store,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("store").document(store.uid).updateData(["isClosed":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
        
    }
    func openStore(
        store:Store,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("store").document(store.uid).updateData(["isClosed":false]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
        
    }
    
    func addItem(item:Product,requestComplete:@escaping(_ status:Bool)->()){
        let docData = try! FirestoreEncoder().encode(item)
        
        db.collection("product").document(item.uid).setData( docData){ (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func listMyStore(requestComplete:@escaping(_ storeList:[StoreDocument])->()){
        var storeList = [StoreDocument]()
        
        let dbRef = db.collection("store").whereField("ownerId", isEqualTo: (userGlobal?.uid)!)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(storeList)
                }else{
                    for items in document{
                        let docData = items.data()
                        let store = try! FirestoreDecoder().decode(Store.self, from: docData)
                        let storeDoc = StoreDocument(documentId: items.documentID, store: store)
                        storeList.append(storeDoc)

                        
                    }
                    requestComplete(storeList)
                    
                }
            }
        
        }
    }
    
    func listMyStoreProducts(store:Store,requestComplete:@escaping(_ productList:[ProductDocument])->()){
        var productList = [ProductDocument]()
        
        let dbRef = db.collection("product").whereField("sid", isEqualTo: store.uid)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(productList)
                }else{
                    for items in document{
                        let docData = items.data()
                        let product = try! FirestoreDecoder().decode(Product.self, from: docData)
                        let productDoc = ProductDocument(documentId: items.documentID, product: product)
                        productList.append(productDoc)

                        
                    }
                    requestComplete(productList)
                    
                }
            }
        
        }
    }
    
    func updateProductStock(product:ProductDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("product").document(product.documentId!).updateData(["count":product.product?.count]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func updateProduct(product:ProductDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("product").document(product.documentId!).updateData(["details":product.product?.details,"price":product.product?.price,"profileImage":product.product?.profileImage,"name":product.product?.name,"type":product.product?.type,"count":product.product?.count]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func deleteProduct(product:ProductDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("product").document(product.documentId!).updateData(["isDisabled":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    func reactivateProduct(product:ProductDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("product").document(product.documentId!).updateData(["isDisabled":false]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    
//    func deleteProduct(product:ProductDocument,requestComplete:@escaping(_ status:Bool)->()){
//        let storage = Storage.storage()
//        db.collection("product").document(product.documentId!).delete { (err) in
//            if err == nil{
//                let images = product.product?.uid
//                print("deleting..")
//                let storageRef = storage.reference().child("UsersFiles").child(userGlobal!.uid).child("Store")
//                storageRef.child("\((product.product?.uid)!)").delete { (error) in
//                    print("done")
//                    if error != nil{
//                        return
//                    }else{
//                        
//                        requestComplete(true)
//                    }
//                    
//                }
//            }
//        }
//    }
}
