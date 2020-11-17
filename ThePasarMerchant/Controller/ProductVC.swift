//
//  ProductVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    // First timers Hint
    @IBOutlet weak var mainHintContainer: UIView!
    @IBOutlet weak var firstHint: UIView!
    @IBOutlet weak var firstBlinky: UIImageView!
    @IBOutlet weak var secondHint: UIView!
    @IBOutlet weak var secondBlinky: UIImageView!
    
    var page = 1
    let defaults = UserDefaults.standard
    //
    
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
        mainHintContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
        
        
    }
    
    @objc func nextHint(){
        if page == 1{
            firstHint.isHidden = true
            secondHint.isHidden = false
            page = 2
        }else if page == 2{
            secondHint.isHidden = true
            mainHintContainer.isHidden = true
            defaults.set(true, forKey: "productTabHint")
            
        }
    }
    @objc func backgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    

    @objc func addProduct(){
        let addProduct = addProductPopup()
        addProduct.store = myStore
        addProduct.delegate = self
        addProduct.currentTotalProduct = productList.count
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    func editAction(at indexPath:IndexPath) -> UIContextualAction {
        let done = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            let selectedProduct = self.productList[indexPath.row]
            let editPopup = addProductPopup()
            editPopup.isEdit = true
            editPopup.delegate = self
            editPopup.product = selectedProduct
            editPopup.modalPresentationStyle = .custom
            self.present(editPopup, animated: true, completion: nil)

            
        }
        done.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return done
    }
    func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
        let done = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            let selectedProduct = self.productList[indexPath.row]
            //
//            self.productList.remove(at: indexPath.row)
//            self.productTable.deleteRows(at: [indexPath], with: .automatic)
//            self.productTable.reloadData()
            let deletePopup = UIAlertController(title: "Remove Product?", message: "Are you sure you want to remove this product?", preferredStyle: .alert)
            deletePopup.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (buttonTapped) in
                StoreServices.instance.deleteProduct(product: selectedProduct) { (isSuccess) in
                    if isSuccess{
                        print("deleted")
                        self.productList.remove(at: indexPath.row)
                        self.productTable.deleteRows(at: [indexPath], with: .automatic)
                        self.productTable.reloadData()
                    }

                }


            }))
            deletePopup.addAction(UIAlertAction(title: "No", style: .default, handler: { (buttonTapped) in
                deletePopup.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))


            }))

            self.present(deletePopup, animated: true, completion:  {

                deletePopup.view.superview?.isUserInteractionEnabled = true
                deletePopup.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
            })
            
            
        }
        
        done.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return done
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
            if productlist.count == 0{
                let isFirstTime = UserDefaults.exist(key: "productTabHint")
                if isFirstTime == false{
                    self.firstTimeHelper()
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
}
