//
//  MainTabVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 24/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import AwesomeSpotlightView

class MainTabVC: UIViewController {

    let defaults = UserDefaults.standard
    //
    
    
    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    
    //ButtonConstaint

    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var purchasesBtn: UIButton!
    @IBOutlet weak var restockBtn: UIButton!
    
    var multipleStore = false
    var choosenStore:StoreDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        accountBtn.contentMode = .center
        accountBtn.imageView?.contentMode = .scaleAspectFit
        productBtn.contentMode = .center
        productBtn.imageView?.contentMode = .scaleAspectFit
        purchasesBtn.contentMode = .center
        purchasesBtn.imageView?.contentMode = .scaleAspectFit
        restockBtn.contentMode = .center
        restockBtn.imageView?.contentMode = .scaleAspectFit

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
                destination.myStore = choosenStore?.store
            
            
            
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
                self.performSegue(withIdentifier: "productSegue", sender: self)
            choosenStore = userGlobalStores.first
                

            
        }else{
            let storeList = multipleStoreSelection()
            storeList.storeList = userGlobalStores
            storeList.delegate = self
            present(storeList, animated: true, completion: nil)
            
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
extension MainTabVC: hasStoreDelegate,chooseStoreDelegate{
    func storeChoosen(store: StoreDocument) {
        choosenStore = store
        self.performSegue(withIdentifier: "productSegue", sender: self)
    }
    
    func hasStore(status: Bool) {
        if status{
            popupBackground.isHidden = true
            popupView.isHidden = true
            let isFirstTime = UserDefaults.exist(key: "addOrderHintDone")
            print(isFirstTime)
            if isFirstTime == false{
                loadStore()

            }
        }
    }
    
    
}

extension MainTabVC:AwesomeSpotlightViewDelegate{
    
    func initLayout(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        let navLabel = UILabel()
//        let navTitle = NSMutableAttributedString(string: "Orders ", attributes: [NSAttributedString.Key.font :UIFont(name: "Helvetica-Neue", size: 20.0)!,NSMutableAttributedString.Key.foregroundColor: UIColor.white])
//
//        navLabel.attributedText = navTitle
        self.navigationItem.title = "Pasar Merchant"
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    func loadStore(){
        StoreServices.instance.listMyStore { (storelist) in
            userGlobalStores = storelist
            let isFirstTime = UserDefaults.exist(key: "mainTabHint")
            print(isFirstTime)
            if isFirstTime == false{
                self.spotlght()
            }
        }
    }
    
    
    func spotlght(){


        //Account Btn
        let accBtnWidth = accountBtn.frame.size.width
        let accBtnHeight = accountBtn.frame.size.height
        let accBtnSpotlight = CGRect(x:accountBtn.frame.origin.x, y: accountBtn.frame.origin.y + (accBtnHeight/2), width: accBtnWidth, height: accBtnWidth)
        var spotText = "To view you monthly sales"
        let spotlight1 = AwesomeSpotlight(withRect: accBtnSpotlight, shape: .circle, text: spotText)

        //Product Btn
        let prdBtnWidth = productBtn.frame.size.width
        let prdBtnHeight = productBtn.frame.size.height
        let prdBtnSpotlight = CGRect(x:productBtn.frame.origin.x, y: productBtn.frame.origin.y + (prdBtnHeight/2), width: prdBtnWidth, height: prdBtnWidth)
        spotText = "To add product to your store(s)"
        let spotlight2 = AwesomeSpotlight(withRect: prdBtnSpotlight, shape: .circle, text: spotText)

        
        //Purchases Btn
        let pchBtnWidth = purchasesBtn.frame.size.width
        let pchBtnHeight = purchasesBtn.frame.size.height
        let pchBtnSpotlight = CGRect(x:purchasesBtn.frame.origin.x, y: purchasesBtn.frame.origin.y + (pchBtnHeight/2 + pchBtnHeight), width: pchBtnWidth, height: pchBtnWidth)
        spotText = "To view where is your next deliveries"
        let spotlight3 = AwesomeSpotlight(withRect: pchBtnSpotlight, shape: .circle, text: spotText)
        
        //Restock Btn
        let rskBtnWidth = restockBtn.frame.size.width
        let rskBtnHeight = restockBtn.frame.size.height
        let rskBtnSpotlight = CGRect(x:restockBtn.frame.origin.x, y: restockBtn.frame.origin.y + (rskBtnHeight/2 + rskBtnHeight), width: prdBtnWidth, height: prdBtnWidth)
        spotText = "To update your current stock"
        let spotlight4 = AwesomeSpotlight(withRect: rskBtnSpotlight, shape: .circle, text: spotText)
        
        //OrderTab
        let orderTab = frameForTabAtIndex(index: 1)
        let orderSpotlight = CGRect(x:orderTab.origin.x + (35/2), y: orderTab.origin.y, width: 60, height: 60)
        spotText = "To view your incoming orders"
        let spotlight5 = AwesomeSpotlight(withRect: orderSpotlight, shape: .circle, text: spotText)
        
        //Complaintab
        let compTab = frameForTabAtIndex(index: 2)
        let compSpotlight = CGRect(x:compTab.origin.x + (35/2), y: compTab.origin.y, width: 60, height: 60)
        spotText = "To view customer complaints"
        let spotlight6 = AwesomeSpotlight(withRect: compSpotlight, shape: .circle, text: spotText)
        
        //Complaintab
        let proTab = frameForTabAtIndex(index: 3)
        let proSpotlight = CGRect(x:proTab.origin.x + (35/2), y: proTab.origin.y, width: 60, height: 60)
        spotText = "To edit and add stores"
        let spotlight7 = AwesomeSpotlight(withRect: proSpotlight, shape: .circle, text: spotText)
        
        
        let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlight1,spotlight2,spotlight3,spotlight4,spotlight5,spotlight6,spotlight7])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
        view.addSubview(spotlightView)
        spotlightView.start()
        print("Done")
    }
    private func frameForTabAtIndex(index: Int) -> CGRect {
        guard let tabBarSubviews = tabBarController?.tabBar.subviews else {
            return CGRect.zero
        }
        var allItems = [UIView]()
        for tabBarItem in tabBarSubviews {
            if tabBarItem.isKind(of: NSClassFromString("UITabBarButton")!) {
                allItems.append(tabBarItem)
            }
        }
        let item = allItems[index]
        return item.superview!.convert(item.frame, to: view)
    }

    func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int) {
        print(index)
        if index == 6 {
            defaults.set(true, forKey: "mainTabHint")
        }
    }
}

//extension UITabBar{
//    func getFrameAt(index:Int)->CGRect?{
//        var frame = self.subviews.compactMap{return $0 is UIControl ? $0.frame : nil}
//        frame.sort{ $0.origin.x < $1.origin.x}
//        return frame[safe:index]
//    }
//
//}
//
//extension Collection{
//    subscript(safe index: Index)-> Element?{
//        return indices.contains(index) ? self[index]:nil
//    }
//}
