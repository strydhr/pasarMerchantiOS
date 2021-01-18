//
//  Complaint.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 15/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

class Complaint: Codable{
    var items:[itemPurchasing]
    var date: Timestamp
    var deliveryTime:Timestamp
    var purchaserId:String
    var purchaserName:String
    var purchaserAddress:String
    var purchaserPhone:String
    var storeId:String
    var storeName:String
    var ownerId:String
    var receiptId:String
    var complaint:String
    var isResolved:Bool
    
    init(items:[itemPurchasing],date:Timestamp,deliveryTime:Timestamp,purchaserId:String,purchaserName:String,purchaserAddress:String,purchaserPhone:String,storeId:String,storeName:String,ownerId:String,receiptId:String,complaint:String,isResolved:Bool) {
        self.items = items
        self.date = date
        self.deliveryTime = deliveryTime
        self.purchaserId = purchaserId
        self.purchaserName = purchaserName
        self.purchaserAddress = purchaserAddress
        self.purchaserPhone = purchaserPhone
        self.storeId = storeId
        self.storeName = storeName
        self.ownerId = ownerId
        self.receiptId = receiptId
        self.complaint = complaint
        self.isResolved = isResolved
    }
}

struct ComplaintDocument {
    var documentId:String?
    var complaint:Complaint?
}
