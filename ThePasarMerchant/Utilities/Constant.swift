//
//  Constant.swift
//  ThePasar
//
//  Created by Satyia Anand on 22/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import Foundation

let GOOGLEAPI = googlekey
let serverKey = serverkey

var userGlobal:Merchant?
//var userStores = [Store]()
var userGlobalStores = [StoreDocument]()

func autoID(length: Int)->String{
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length - 1).map{ _ in letters.randomElement()!})
}

func getDateLabel(dates:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let dateStr = formatter.string(from: dates)
    return dateStr
}

func getTimeLabel(dates:Date)->String{
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "hh:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    let dateStr = formatter.string(from: dates)
    return dateStr
}

func getDateTimeLabel(dates:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy 'at' hh:mm a"
    let dateStr = formatter.string(from: dates)
    return dateStr
}

func dateChecker(date:Date)->Bool{
    let calendar = Calendar.current
    let orderDay = calendar.component(.day, from: date)
    print(orderDay)
    let date = Date()
    let todayDay = calendar.component(.day, from: date)
    
    if todayDay == orderDay{
        
        return true
    }else{
        return false
    }
}
