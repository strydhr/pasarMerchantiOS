//
//  Product.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

class Product: Codable {
    var uid:String
    var name: String
    var type:String
    var details:String
    var sid: String
    var count: Int
    var price: Double
    var availability:Bool
    var profileImage:String
    var hasCounter:Bool
    
    init(uid:String,name:String,type:String,details:String,sid:String,count:Int,price:Double,availability:Bool,profileImage:String,hasCounter:Bool) {
        self.uid = uid
        self.name = name
        self.type = type
        self.details = details
        self.sid = sid
        self.count = count
        self.price = price
        self.availability = availability
        self.profileImage = profileImage
        self.hasCounter = hasCounter
    }
}

struct ProductDocument{
    var documentId:String?
    var product: Product?
}
