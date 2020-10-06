//
//  RestockVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 15/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class RestockVC: UIViewController {
    @IBOutlet weak var stockTable: UITableView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var currentStockList = [ProductDocument]()
    var myStore:Store?
    var productList = [ProductDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        loadStock()
        stockTable.register(UINib(nibName: "stockCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        
        stockTable.delegate = self
        stockTable.dataSource = self
    }
    

    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        updateStock()
//        test()
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
extension RestockVC:UITableViewDelegate,UITableViewDataSource{
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return productList.count
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 151
          
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell")as? stockCell else {return UITableViewCell()}
          let product = productList[indexPath.row].product
          cell.productImage.cacheImage(imageUrl: product!.profileImage)
          cell.productName.text = product?.name
        cell.productCount.text = "\((product?.count)!)"
        cell.delegate = self
        cell.product = productList[indexPath.row]
//          cell.productPrice.text = "RM" + String(format: "%.2f", product!.price)
//          cell.productDetails.text = product?.details
          
          return cell
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension RestockVC{
    func loadDatas(){
        StoreServices.instance.listMyStoreProducts(store: (userGlobalStores.first?.store)!) { (productlist) in
//            self.currentStockList = productlist
            
            self.productList = productlist.filter({$0.product?.type == "Handmade" })
            
            self.productList = self.productList.sorted(by: {$0.product!.count > $1.product!.count})
            self.stockTable.reloadData()
        }
    }
    func loadStock(){
        StoreServices.instance.listMyStoreProducts(store: (userGlobalStores.first?.store)!) { (productlist) in
            self.currentStockList = productlist
            
        }
    }
    
    func updateStock(){
        for item in productList{
            let focusProduct = currentStockList.filter({$0.documentId == item.documentId}).first
            if  (item.product!.count > (focusProduct?.product!.count)! ||  item.product!.count < (focusProduct?.product!.count)!){
                StoreServices.instance.updateProductStock(product: item) { (isSuccess) in
                    if isSuccess{
                        print("Updated : \(item.documentId)")
                    }
                }
            }
        }
    }
    
}

extension RestockVC:StockDelegate{
    func decreaseStock(product: ProductDocument) {
        if let productIndex = self.productList.firstIndex(where: {$0.documentId == product.documentId}){
            self.productList[productIndex].product!.count -= 1
            stockTable.reloadData()
        }
    }
    
    func increaseStock(product: ProductDocument) {
        if let productIndex = self.productList.firstIndex(where: {$0.documentId == product.documentId}){
            self.productList[productIndex].product!.count += 1
            stockTable.reloadData()

        }
    }
    
    
}
