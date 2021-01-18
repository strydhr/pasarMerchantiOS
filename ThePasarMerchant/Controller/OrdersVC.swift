//
//  OrdersVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
// Add alert to call customer when stock is not enough

import UIKit
import CoreLocation

class OrdersVC: UIViewController {
    //First Time Hints
    @IBOutlet weak var mainHintContainer: UIView!
    @IBOutlet weak var firstHint: UIView!
    @IBOutlet weak var firstBlinky: UIImageView!
    @IBOutlet weak var secondHint: UIView!
    @IBOutlet weak var secondBlinky: UIImageView!
    
    var page = 1
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var ordersTable: UITableView!
    
    var ordersList = [OrderDocument]()
    
    var productList = [ProductDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
        loadDatas()
        
        ordersTable.delegate = self
        ordersTable.dataSource = self
        ordersTable.separatorStyle = .none
        ordersTable.register(UINib(nibName: "orderHeader", bundle: nil), forCellReuseIdentifier: "orderHeader")
        ordersTable.register(UINib(nibName: "orderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }
    

    @objc func nextHint(){
        if page == 1{
            firstHint.isHidden = true
            secondHint.isHidden = false
            page = 2
        }else if page == 2{
            secondHint.isHidden = true
            mainHintContainer.isHidden = true
            defaults.set(true, forKey: "ordersTabHint")
        }
    }

}
extension OrdersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderHeader")as? orderHeader else {return UITableViewCell()}
        let header = ordersList[section]
        cell.deliveryAddress.text = header.order?.purchaserAddress
        cell.delegate = self
        cell.delegate2 = self
        cell.item = header
        var totalItems = 0
        for item in header.order!.items{
            totalItems += item.itemCount
        }
        //
        if let store = userGlobalStores.filter({$0.store?.uid == header.order?.storeId}).first{
            let coor1 = CLLocation(latitude: (store.store?.l[0])!, longitude: (store.store?.l[1])!)
            let coor2 = CLLocation(latitude: (header.order?.purchaserCoor[0])!, longitude: (header.order?.purchaserCoor[1])!)
            let dist = String(format: "%0.2f", coor1.distance(from: coor2)/1000)
            cell.distance.text = "\(dist) km"
        }
        //
        
        cell.orderCount.text = String(totalItems)
        cell.deliveryTime.text = getTimeLabel(dates: header.order!.deliveryTime.dateValue())
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList[section].order!.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell")as? orderCell else {return UITableViewCell()}
        let item = ordersList[indexPath.section].order!.items[indexPath.row]
        cell.orderCount.text = String(item.itemCount)
        cell.orderName.text = item.productName
        cell.setupCell()
        cell.isResolved = false
        
        if !item.hasDeliveryTime{
            cell.stockCntBg.isHidden = false
            if let productIndex = self.productList.firstIndex(where: {$0.documentId == item.productId}){
                cell.stockCount.text = "\((productList[productIndex].product?.count)!)"
            }
        }else{
            cell.stockCntBg.isHidden = true
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension OrdersVC{
    func loadDatas(){
        OrderServices.instance.realtimeOrderListUpdate{ (orderlist) in
//            let todaysDate = Date()
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.day], from: todaysDate)
//            let startOfDay = calendar.startOfDay(for: todaysDate)
//            self.ordersList = orderlist.filter({$0.order!.deliveryTime.dateValue() > todaysDate})
//            print(orderlist.count)
            self.ordersList = orderlist.sorted(by: {$0.order!.deliveryTime.dateValue().compare($1.order!.deliveryTime.dateValue()) == .orderedDescending})
            self.ordersTable.reloadData()
            if orderlist.count > 0{
                let isFirstTime = UserDefaults.exist(key: "ordersTabHint")
                if isFirstTime == false{
                    self.firstTimeHelper()
                    self.mainHintContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextHint)))
                }
            }
        }
    }
    func firstTimeHelper(){
        mainHintContainer.isHidden = false
        firstHint.isHidden = false
        secondHint.isHidden = true
        page = 1
        
        self.firstBlinky.alpha = 0
        self.secondBlinky.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.firstBlinky.alpha = 1
            self.secondBlinky.alpha = 1
        } completion: { (success) in
            
        }

    }
    
    func loadProduct(){
        StoreServices.instance.listMyStoreProducts(store: userGlobalStores.first!.store!) { (productlist) in
            self.productList = productlist
            self.ordersTable.reloadData()
        }
    }
    
}

extension OrdersVC:rejectOrderDelegate,confirmOrderDelegate,removeRejectedOrderDelegate{
    func removeFromList(item: OrderDocument) {
        if let removeOrderIndex = ordersList.firstIndex(where: {$0.documentId == item.documentId}){
            ordersList.remove(at: removeOrderIndex)
            self.ordersTable.reloadData()
        }
    }
    
    func rejectOrder(item: OrderDocument) {
        let rejectedPopup = rejectedCommentPopup()
        rejectedPopup.order = item
        rejectedPopup.delegate = self
        rejectedPopup.modalPresentationStyle = .custom
        present(rejectedPopup, animated: true, completion: nil)
    }
    
//    func csonfirmOrder(item: OrderDocument) {
//        OrderServices.instance.confirmReadyOrder(order: item) { (isSuccess) in
//            if isSuccess{
//                if let confirmOrderIndex = self.ordersList.firstIndex(where: {$0.documentId == item.documentId}){
//                    self.ordersList.remove(at: confirmOrderIndex)
////                    self.ordersList[confirmOrderIndex].order?.confirmationStatus = 2
////                    self.ordersList[confirmOrderIndex].order?.hasDelivered = true
//                    OrderServices.instance.updateStock(productList: self.productList, order: item) { (isSuccess,productlist)  in
//                        self.productList = productlist
//                        self.ordersTable.reloadData()
//                    }
//                    
//                }
//            }
//        }
//    }
    
    func confirmOrder(item: OrderDocument) {
        if item.order!.hasDeliveryTime{
            OrderServices.instance.confirmReadyOrder(order: item) { (isConfirmed) in
                if isConfirmed{
                    NotificationServices.instance.sendNotification(deviceToken: item.order!.purchaserDeviceToken, title: "Order Confirmed", body: "We are preparing your order")
                    if let confirmOrderIndex = self.ordersList.firstIndex(where: {$0.documentId == item.documentId}){
                        self.ordersList.remove(at: confirmOrderIndex)
                        self.ordersTable.reloadData()
                    }
                    
                }
            }
        }else{
            OrderServices.instance.isStockEnough(productList: productList, order: item) { (isSuccess) in
                if isSuccess{
                    print("yes")
                    OrderServices.instance.updateStock(productList: self.productList, order: item) { (doneUpdating, newUpdatedList) in
                        if doneUpdating{
                            self.productList = newUpdatedList
                            OrderServices.instance.confirmStockOrder(order: item) { (isConfirmed) in
                                if isConfirmed{
                                    NotificationServices.instance.sendNotification(deviceToken: item.order!.purchaserDeviceToken, title: "Order Confirmed", body: "We will contact you when we are about to send your order")
                                    if let confirmOrderIndex = self.ordersList.firstIndex(where: {$0.documentId == item.documentId}){
                                        self.ordersList.remove(at: confirmOrderIndex)
                                        self.ordersTable.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                }else{
                    let contact = item.order?.purchaserPhone
                    let alert = UIAlertController(title: "Not enough stock", message: "Please call customer that there aren't enough stock", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Phone", style: .default, handler: { (photoAlert) in
                        if let url = URL(string: "tel://\(contact)"), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { (libraryAlert) in 
                        let urlWhats = "https://wa.me/\(contact)"
                        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                            if let whatsappURL = URL(string: urlString) {
                                if UIApplication.shared.canOpenURL(whatsappURL){
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(whatsappURL)
                                    }
                                }
                                else {
                                }
                            }
                        }
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (libraryAlert) in
                        print("Cancel")
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        
        
    }
    
    
}
