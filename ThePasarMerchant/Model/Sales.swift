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

struct GroupedProduct{
    var ProductName:String?
    var totalSales:Int?
}

struct test {
    var count:Double
    var type:String
}
