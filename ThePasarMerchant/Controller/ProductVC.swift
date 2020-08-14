//
//  ProductVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    @IBOutlet weak var productTable: UITableView!
    
    var addBtn = UIBarButtonItem()
    var myStore:Store?
    var productList = [ProductDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn = UIBarButtonItem(title: "Add Item", style: .done, target: self, action: #selector(addProduct))
        navigationItem.rightBarButtonItems = [addBtn]
        productTable.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "productCell")
        
        productTable.delegate = self
        productTable.dataSource = self
        

        loadDatas()
        
        
    }
    

    @objc func addProduct(){
        let addProduct = addProductPopup()
        addProduct.store = myStore
        addProduct.delegate = self
        addProduct.modalPresentationStyle = .custom
        present(addProduct, animated: true, completion: nil)
    }

}
extension ProductVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell")as? productCell else {return UITableViewCell()}
        let product = productList[indexPath.row].product
        cell.productImage.cacheImage(imageUrl: product!.profileImage)
        cell.productName.text = product?.name
        cell.productPrice.text = "RM" + String(format: "%.2f", product!.price)
        cell.productDetails.text = product?.details
        
        return cell
    }
    
    
}

extension ProductVC:updateProductsDelegate{
    func reloadTable() {
        loadDatas()
    }
    

}

extension ProductVC{
    func loadDatas(){
        StoreServices.instance.listMyStoreProducts(store: myStore!) { (productlist) in
            self.productList = productlist
            self.productTable.reloadData()
        }
    }
}
