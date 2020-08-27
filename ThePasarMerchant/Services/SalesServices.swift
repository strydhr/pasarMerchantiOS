//
//  SalesServices.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 26/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class SalesServices {
    static let instance = SalesServices()
    
    func listMySales(requestComplete:@escaping(_ salesList:[Receipts])->()){
        var salesList = [Receipts]()
        
        let dbRef = db.collection("receipt").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("caseClosed", isEqualTo: true)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(salesList)
                }else{
                    for items in document{
                        let docData = items.data()
                        print(docData)
                        let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
                        salesList.append(receipts)

                        
                    }
                    requestComplete(salesList)
                    
                }
            }
        
        }
    }
}
