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
    // Hints for First timers
    @IBOutlet weak var hintMainContainer: UIView!
    @IBOutlet weak var firstHint: UIView!
    @IBOutlet weak var firstBlinky: UIImageView!
    @IBOutlet weak var secondHint: UIView!
    @IBOutlet weak var secondBlinky: UIImageView!
    @IBOutlet weak var thirdHint: UIView!
    @IBOutlet weak var thirdBlinky: UIImageView!
    @IBOutlet weak var fourthHint: UIView!
    @IBOutlet weak var fourthBlinky: UIImageView!
    
    var page = 1
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
        spotlght()
        accountBtn.contentMode = .center
        accountBtn.imageView?.contentMode = .scaleAspectFit
        productBtn.contentMode = .center
        productBtn.imageView?.contentMode = .scaleAspectFit
        purchasesBtn.contentMode = .center
        purchasesBtn.imageView?.contentMode = .scaleAspectFit
        restockBtn.contentMode = .center
        restockBtn.imageView?.contentMode = .scaleAspectFit
        
        hintMainContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
        if userGlobal?.storeCount == 0{
            popupBackground.isHidden = false
            popupView.isHidden = false
        }else{
            loadStore()
        }

    }
    
    @objc func nextHint(){
        if page == 1{
            firstHint.isHidden = true
            secondHint.isHidden = false
            page = 2
        }else if page == 2{
            secondHint.isHidden = true
            thirdHint.isHidden = false
            page = 3
        }else if page == 3{
            thirdHint.isHidden = true
            fourthHint.isHidden = false
            page = 4
        }else if page == 4{
            fourthHint.isHidden = true
            hintMainContainer.isHidden = true
            defaults.set(true, forKey: "mainTabHint")
            
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
                firstTimeHelper()
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
        
        
        
    }
    func loadStore(){
        StoreServices.instance.listMyStore { (storelist) in
            userGlobalStores = storelist
            let isFirstTime = UserDefaults.exist(key: "mainTabHint")
            print(isFirstTime)
            if isFirstTime == false{
                self.firstTimeHelper()
            }
        }
    }
    
    func firstTimeHelper(){
        hintMainContainer.isHidden = false
        firstHint.isHidden = false
        secondHint.isHidden = true
        thirdHint.isHidden = true
        fourthHint.isHidden = true
        page = 1
        
        self.firstBlinky.alpha = 0
        self.secondBlinky.alpha = 0
        self.thirdBlinky.alpha = 0
        self.fourthBlinky.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.firstBlinky.alpha = 1
            self.secondBlinky.alpha = 1
            self.thirdBlinky.alpha = 1
            self.fourthBlinky.alpha = 1
        } completion: { (success) in
            
        }

    }
    
    func spotlght(){
        let height = frameForTabAtIndex(index: 1)
        print(height.origin.y)
        let accBtnSpotlight = CGRect(x: height.origin.x, y: height.origin.y, width: 100, height: 100)
        let accBtnMargin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let spotlight1 = AwesomeSpotlight(withRect: accBtnSpotlight, shape: .circle, text: "Spotlight 1")
        
        let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlight1])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
        view.addSubview(spotlightView)
        spotlightView.start()
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
