//
//  ComplaintServices.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 18/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class ComplaintServices {
    static let instance = ComplaintServices()
    
    func listMyComplaint(requestComplete:@escaping(_ complaintList:[ComplaintDocument])->()){
        var complaintList = [ComplaintDocument]()
        
        let dbRef = db.collection("complaints").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("isResolved", isEqualTo: false)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(complaintList)
                }else{
                    for items in document{
                        let docData = items.data()
                    
                        let complaints = try! FirestoreDecoder().decode(Complaint.self, from: docData)
                        let complaintDoc = ComplaintDocument(documentId: items.documentID, complaint: complaints)
                        complaintList.append(complaintDoc)

                        
                    }
                    requestComplete(complaintList)
                    
                }
            }
        
        }
    }
    func resolveComplaint(complaint:ComplaintDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("complaints").document(complaint.documentId!).updateData(["isResolved":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
}
