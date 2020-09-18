//
//  MainTabVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 24/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class MainTabVC: UIViewController {
    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    
//    var storeList = [StoreDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userGlobal?.storeCount == 0{
            popupBackground.isHidden = false
            popupView.isHidden = false
        }else{
            loadStore()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerStoreSegue"{
            let destination = segue.destination as! RegisterStoreVC
            destination.delegate = self
        }else if segue.identifier == "productSegue"{
            let destination = segue.destination as! ProductVC
            destination.myStore = userGlobalStores.first?.store
            
            
        }else if segue.identifier == "confirmedOrderSegue"{
            
        }else if segue.identifier == "salesSegue"{
            let destination = segue.destination as! SalesVC
            destination.myStore = userGlobalStores.first?.store
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "registerStoreSegue", sender: self)
    }
    @IBAction func productBtnPressed(_ sender: UIButton) {
        if userGlobal?.storeCount == 1{
            StoreServices.instance.listMyStore { (storelist) in
//                self.storeList = storelist
                self.performSegue(withIdentifier: "productSegue", sender: self)
                
                
            }
            
        }
    }
    @IBAction func purchasesBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "confirmedOrderSegue", sender: self)
    }
    
    @IBAction func accountBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "salesSegue", sender: self)
    }
    
    @IBAction func restockBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "restockSegue", sender: self)
    }
    
}
extension MainTabVC: hasStoreDelegate{
    func hasStore(status: Bool) {
        if status{
            popupBackground.isHidden = true
            popupView.isHidden = true
        }
    }
    
    
}

extension MainTabVC{
    func loadStore(){
        StoreServices.instance.listMyStore { (storelist) in
            userGlobalStores = storelist
            
        }
    }
}
