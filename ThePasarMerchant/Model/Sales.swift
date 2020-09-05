//
//  Sales.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 27/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

struct SalesMonth{
    var Month:Int?
    var monthName:String?
    var salesList: [Receipts]?
}

struct GroupedProduct:Comparable{
    let ProductName:String
    let totalSales:Int
    
    static func < (lhs: GroupedProduct, rhs: GroupedProduct) -> Bool {
        return lhs.totalSales < rhs.totalSales
    }
    static func == (lhs: GroupedProduct, rhs: GroupedProduct) -> Bool {
        return lhs == rhs
    }
    
    
}

struct test {
    var count:Double
    var type:String
}
