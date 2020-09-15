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
        cell.deliveryAddress.text = header.order?.purchaserAddress
        cell.delegate = self
        cell.delegate2 = self
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
            self.ordersList = orderlist
            self.ordersTable.reloadData()
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
                                    if let confirmOrderIndex = self.ordersList.firstIndex(where: {$0.documentId == item.documentId}){
                                        self.ordersList.remove(at: confirmOrderIndex)
                                        self.ordersTable.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                }else{
                    let appliedDoneAlert = UIAlertController(title: "Not enough stock", message: "Please call customer that there aren't enough stock", preferredStyle: .alert)
                    self.present(appliedDoneAlert, animated: true, completion: nil)
                    let timer = DispatchTime.now() + 3.5
                    DispatchQueue.main.asyncAfter(deadline: timer, execute: {
                        appliedDoneAlert.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
        
        
        
        
    }
    
    
}
