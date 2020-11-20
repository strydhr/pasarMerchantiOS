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
        cell.deliveryAddress.text = header.order?.purchaserAddress
        cell.delegate = self
        cell.item = header
        var totalItems = 0
        for item in header.order!.items{
            totalItems += item.itemCount
        }
        
        cell.orderCount.text = String(totalItems)
        if header.order!.hasDeliveryTime{
            cell.deliveryTime.text = getTimeLabel(dates: header.order!.deliveryTime.dateValue())
        }else{
            cell.deliveryTime.text = getDateLabel(dates: header.order!.deliveryTime.dateValue())
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 115
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

        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension ConfirmedOrdersVC{
    func loadDatas(){
        OrderServices.instance.realtimeReceiptListUpdate{ (orderlist) in
//            let todaysDate = Date()
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.day], from: todaysDate)
//            let startOfDay = calendar.startOfDay(for: todaysDate)
//            self.ordersList = orderlist.filter({$0.order!.deliveryTime.dateValue() > todaysDate})
//            print(orderlist.count)
            self.ordersList = orderlist
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
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.firstBlinky.alpha = 1
            self.secondBlinky.alpha = 1
            self.thirdBlinky.alpha = 1
        } completion: { (success) in
            
        }

    }
}

extension ConfirmedOrdersVC:completeOrderDelegate{
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
                    self.ordersList[doneDeliveredIndex].order?.hasDelivered = true
                    self.ordersTable.reloadData()
                }
            }
        }
    }
    
    
}
