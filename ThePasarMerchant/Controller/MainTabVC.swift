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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userGlobal?.storeCount == 0{
            popupBackground.isHidden = false
            popupView.isHidden = false
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
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
