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

}
