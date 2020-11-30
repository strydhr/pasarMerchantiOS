//
//  Store.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

extension Timestamp: TimestampType{}

class Store: Codable {
    var uid:String
    var name: String
    var type:String
    var location: String
    var l: [Double]
    var g:String
    var startDate:Timestamp
    var ownerId:String
    var profileImage:String
    var isEnabled:Bool
    var isClosed:Bool
    var deviceToken:String
    
    init(uid:String,name:String,type:String,location:String,lat:Double,lng:Double,g:String,startDate:Timestamp,ownerId:String,profileImage:String,isEnabled:Bool,isClosed:Bool,deviceToken:String) {
        self.uid = uid
        self.name = name
        self.type = type
        self.location = location
        self.l = [lat,lng]
        self.g = g
        self.startDate = startDate
        self.ownerId = ownerId
        self.profileImage = profileImage
        self.isEnabled = isEnabled
        self.isClosed = isClosed
        self.deviceToken = deviceToken
    }
}

struct StoreDocument{
    var documentId:String?
    var store: Store?
}
