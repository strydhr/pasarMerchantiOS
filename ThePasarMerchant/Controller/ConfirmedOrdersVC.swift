//
//  ConfirmedOrdersVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 21/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class ConfirmedOrdersVC: UIViewController {
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
        }
    }
}

extension ConfirmedOrdersVC:completeOrderDelegate{
    func openWaze(item: ReceiptDocument) {
        print(item.order?.purchaserAddress)
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
