//
//  OrdersVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController {
    @IBOutlet weak var ordersTable: UITableView!
    
    var ordersList = [Receipts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        
        ordersTable.delegate = self
        ordersTable.dataSource = self
        ordersTable.separatorStyle = .none
        ordersTable.register(UINib(nibName: "orderHeader", bundle: nil), forCellReuseIdentifier: "orderHeader")
        ordersTable.register(UINib(nibName: "orderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
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
extension OrdersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderHeader")as? orderHeader else {return UITableViewCell()}
        let header = ordersList[section]
        cell.deliveryAddress.text = header.purchaserAddress
        cell.delegate = self
        cell.delegate2 = self
        cell.item = header
        var totalItems = 0
        for item in header.items{
            totalItems += item.itemCount
        }
        
        cell.orderCount.text = String(totalItems)
        cell.deliveryTime.text = getTimeLabel(dates: header.deliveryTime.dateValue())
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell")as? orderCell else {return UITableViewCell()}
        let item = ordersList[indexPath.section].items[indexPath.row]
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

extension OrdersVC{
    func loadDatas(){
        OrderServices.instance.realtimeListUpdate2{ (orderlist) in
            let todaysDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: todaysDate)
            let startOfDay = calendar.startOfDay(for: todaysDate)
            self.ordersList = orderlist.filter({$0.deliveryTime.dateValue() > todaysDate})
            print(orderlist.count)
            self.ordersTable.reloadData()
        }
    }
}

extension OrdersVC:rejectOrderDelegate,confirmOrderDelegate{
    func confirmOrder(item: Receipts) {
        
    }
    
    func rejectOrder(item: Receipts) {
        let rejectedPopup = rejectedCommentPopup()
        rejectedPopup.order = selectedOrder.order
        rejectedPopup.modalPresentationStyle = .custom
        present(rejectedPopup, animated: true, completion: nil)
    }
    
    
}
