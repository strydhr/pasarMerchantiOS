//
//  NotificationServices.swift
//  HomePlus
//
//  Created by Satyia Anand on 23/06/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase



class NotificationServices {
    static let instance = NotificationServices()
    
    func sendNotification(deviceToken:String,title:String,body:String){
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!

        let paramString: [String : Any] = ["to" : deviceToken,
                                               "notification" : ["title" : title, "body" : body],
                                               "data" : ["user" : "test_id"]
            ]
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            task.resume()
        }
        
//    func getLandlordDetails(landlordId:String,requestComplete:@escaping(_ landlord:LandLord)->()){
//        let dbRef = db.collection("landlord").document(landlordId)
//        dbRef.getDocument { (snapshot, error) in
//            if error == nil{
//                guard let snapShot = snapshot?.data() else {return}
//                var landlord = try! FirestoreDecoder().decode(LandLord.self, from: snapShot )
//                requestComplete(landlord)
//            }
//        }
//    }
    

}


