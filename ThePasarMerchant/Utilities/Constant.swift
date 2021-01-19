//
//  Constant.swift
//  ThePasar
//
//  Created by Satyia Anand on 22/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import Foundation

let GOOGLEAPI = "AIzaSyD0B7e0r5qkUK5QQdmQjDOZz1GCBKqTa7Y"
let serverKey = "AAAAUJA7Y08:APA91bG1yX3iyxgdhD3jFB-ag3TlD6HxixV_GAR3aOhz-QoIU7a2s51I_GpWUsCXiRaXSXvguU2kIysHmJfVK5wWlgpC2L17j9ROxba_avFWQ9ciVPZp9U-Aht95BMyGj0Jx2A_cDPz0"

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
    formatter.dateFormat = "hh:mm a"
    let dateStr = formatter.string(from: dates)
    return dateStr
}
