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
        ordersTable.register(UINib(nibName: "orderHeader", bundle: nil), forCellReuseIdentifier: "orderHeader")
        ordersTable.register(UINib(nibName: "orderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }
    

}
extension ConfirmedOrdersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderHeader")as? orderHeader else {return UITableViewCell()}
        let header = ordersList[section]
        cell.deliveryAddress.text = header.order?.purchaserAddress
        cell.confirmBtn.isHidden = true
        cell.rejectBtn.isHidden = true
        cell.item = header
        var totalItems = 0
        for item in header.order!.items{
            totalItems += item.itemCount
        }
        
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

        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension ConfirmedOrdersVC{
    func loadDatas(){
        OrderServices.instance.realtimeListUpdate2{ (orderlist) in
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
