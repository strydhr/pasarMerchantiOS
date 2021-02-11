//
//  ConfirmedOrdersVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 21/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class ConfirmedOrdersVC: UIViewController {
    //FirstTime Hint
    @IBOutlet weak var mainHintContainer: UIView!
    @IBOutlet weak var initialHint: UIView!
    @IBOutlet weak var firstHint: UIView!
    @IBOutlet weak var firstBlinky: UIImageView!
    @IBOutlet weak var secondHint: UIView!
    @IBOutlet weak var secondBlinky: UIImageView!
    @IBOutlet weak var thirdHint: UIView!
    @IBOutlet weak var thirdBlinky: UIImageView!
    @IBOutlet weak var forthHint: UIView!
    @IBOutlet weak var fourthBlinky: UIImageView!
    
    var page = 1
    let defaults = UserDefaults.standard
    //
    
    @IBOutlet weak var ordersTable: UITableView!
    
    var ordersList = [ReceiptDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        
        ordersTable.delegate = self
        ordersTable.dataSource = self
        ordersTable.separatorStyle = .none
        ordersTable.register(UINib(nibName: "receiptHeader", bundle: nil), forCellReuseIdentifier: "receiptHeader")
        ordersTable.register(UINib(nibName: "orderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        ordersTable.sectionHeaderHeight = UITableView.automaticDimension
        ordersTable.estimatedSectionHeaderHeight = 110
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatas()
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
            forthHint.isHidden = false
            page = 4
        }else if page == 4{
            forthHint.isHidden = true
            mainHintContainer.isHidden = true
            defaults.set(true, forKey: "confirmedOrdersTabHint")
        }
    }
    

}
extension ConfirmedOrdersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiptHeader")as? receiptHeader else {return UITableViewCell()}
        let header = ordersList[section]
        let address = header.order!.purchaserAddress
        let wantedString = address.components(separatedBy: ", ")
        var add = ""
        
        for word in wantedString{
            add.append("\(word)\n")
        }
        let finalAdd = add.dropLast(9)
        cell.deliveryAddress.text = String(finalAdd)
        cell.delegate = self
        cell.item = header
        var totalItems = 0
        var total = 0.0
        for item in header.order!.items{
            totalItems += item.itemCount
            let price = item.productPrice * Double(item.itemCount)
            total = total + price
        }
        
        cell.orderCount.text = String(totalItems)
        cell.totalCost.text = "RM \((String(format: "%.2f", total)))"
        if header.order!.hasDeliveryTime{
            let todaysDate = Date()
            let startOfDay = Calendar.current.startOfDay(for: todaysDate)
            if startOfDay > (header.order?.deliveryTime.dateValue())! {
                cell.deliveryLabel.text = "Late Delivery:"
                cell.deliveryTime.text = getDateTimeLabel(dates: header.order!.deliveryTime.dateValue())
            }else{
                cell.deliveryLabel.text = "Delivery Time:"
                cell.deliveryTime.text = getTimeLabel(dates: header.order!.deliveryTime.dateValue())
            }
            

        }else{
            cell.deliveryLabel.text = "Ordered On:"
            cell.deliveryTime.text = getDateLabel(dates: header.order!.date.dateValue())

        }
        
        if header.order!.hasDelivered{
            cell.completeBtn.isHidden = true
            cell.slideBtn.isHidden = true
        }else{
            cell.completeBtn.isHidden = false
            cell.slideBtn.isHidden = false
        }
        

        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 115
//    }
    
    
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

        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension ConfirmedOrdersVC{
    func loadDatas(){
        OrderServices.instance.receiptListUpdate{ (orderlist) in
//            let todaysDate = Date()
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.day], from: todaysDate)
//            let startOfDay = calendar.startOfDay(for: todaysDate)
//            self.ordersList = orderlist.filter({$0.order!.deliveryTime.dateValue() > todaysDate})
//            print(orderlist.count)
//            self.ordersList = orderlist
            self.ordersList = orderlist.sorted(by: {$0.order!.date.dateValue().compare($1.order!.date.dateValue()) == .orderedDescending})
            self.ordersTable.reloadData()
            
            if orderlist.count == 0 {
                self.mainHintContainer.isHidden = false
                self.initialHint.isHidden = false
            }else if orderlist.count > 0{
                let isFirstTime = UserDefaults.exist(key: "confirmedOrdersTabHint")
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
}

extension ConfirmedOrdersVC:completeOrderDelegate{
    func itemizeSales(item: ReceiptDocument) {

        let itemize = itemizePopup()
        itemize.receipt = item.order
        present(itemize, animated: true, completion: nil)
    }
    
    func phoneCustomer(item: ReceiptDocument) {
        let contact = item.order?.purchaserPhone
        let alert = UIAlertController(title: "Contact Customer By:", message: "", preferredStyle: .actionSheet)
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
    //                    let alert = UIAlertController(title: "WhatsApp Error", message: "You require the app WhatsApp to continue", preferredStyle: .alert)
    //                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    //                    alert.addAction(okAction)
    //                    self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (libraryAlert) in
            print("Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
//        let urlWhats = "https://wa.me/+60129695527"
    }
    
    func openWaze(item: ReceiptDocument) {

        let addStr = item.order?.purchaserAddress
        var dataStr = addStr!.replacingOccurrences(of: " ", with: "%20")

        let url = URL(string: "https://waze.com/ul")
        if UIApplication.shared.canOpenURL(url!){
            let urlStr = "https://waze.com/ul?q=\(dataStr)"
            print(urlStr)
            if let urls = URL(string: urlStr){
                UIApplication.shared.openURL(urls)
            }
        }else{
            print("opps")
        }
    }
    
    func completeOrder(item: ReceiptDocument) {
        OrderServices.instance.orderHaveBeenDelivered(receipt: item) { (isSuccess) in
            if isSuccess{
                if let doneDeliveredIndex = self.ordersList.firstIndex(where: {$0.documentId == item.documentId}){
                    NotificationServices.instance.sendNotification(deviceToken: item.order!.purchaserDeviceToken, title: "Order Delivered", body: "We just delivered your order")
                    self.ordersList[doneDeliveredIndex].order?.hasDelivered = true
                    self.ordersTable.reloadData()
                }
            }
        }
    }
    
    
}
