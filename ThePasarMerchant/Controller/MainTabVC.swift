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
    
    var storeList = [StoreDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userGlobal?.storeCount == 0{
            popupBackground.isHidden = false
            popupView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerStoreSegue"{
            let destination = segue.destination as! RegisterStoreVC
            destination.delegate = self
        }else if segue.identifier == "productSegue"{
            let destination = segue.destination as! ProductVC
            destination.myStore = storeList.first?.store
            
            
        }else if segue.identifier == "orderSegue"{
            
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "registerStoreSegue", sender: self)
    }
    @IBAction func productBtnPressed(_ sender: UIButton) {
        if userGlobal?.storeCount == 1{
            StoreServices.instance.listMyStore { (storelist) in
                self.storeList = storelist
                self.performSegue(withIdentifier: "productSegue", sender: self)
                
                
            }
            
        }
    }
    @IBAction func purchasesBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "orderSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MainTabVC: hasStoreDelegate{
    func hasStore(status: Bool) {
        if status{
            popupBackground.isHidden = true
            popupView.isHidden = true
        }
    }
    
    
}
