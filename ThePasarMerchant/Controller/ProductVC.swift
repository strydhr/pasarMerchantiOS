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
    @IBOutlet weak var thirdHint: UIView!
    
    var page = 1
    let defaults = UserDefaults.standard
    //
    @IBOutlet weak var shopIndicatorView: UIView!
    
    @IBOutlet weak var indicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var closeSign: UILabel!
    
    var addBtn = UIBarButtonItem()
    var closeBtn = UIBarButtonItem()
    var openBtn = UIBarButtonItem()
    var myStore:Store?
    var productList = [ProductDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initLayout()
        addBtn = UIBarButtonItem(title: "Add Item", style: .done, target: self, action: #selector(addProduct))
        closeBtn = UIBarButtonItem(title: "Close Shop", style: .done, target: self, action: #selector(closeShop))
        openBtn = UIBarButtonItem(title: "Open Shop", style: .done, target: self, action: #selector(openShop))
        if ((myStore?.isClosed) == true){
            shopIndicatorView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            indicatorHeight.constant = 50
            closeSign.isHidden = false
            navigationItem.rightBarButtonItems = [addBtn,openBtn]
        }else if myStore?.isClosed == false{
            indicatorHeight.constant = 0
            closeSign.isHidden = true
            navigationItem.rightBarButtonItems = [addBtn,closeBtn]
        }
        
        productTable.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "productCell")
        
        productTable.delegate = self
        productTable.dataSource = self
        

        loadDatas()
        mainHintContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
        
        indicatorHeight.isActive = true
        
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
    
    @objc func closeShop(){
        let closeShopPopUP = UIAlertController(title: "Close Shop For the Day?", message: "Are you sure you want to close the shop, you will need to open the back the shop to start receiving orders", preferredStyle: .alert)
        closeShopPopUP.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (buttonTapped) in
            StoreServices.instance.closeStore(store: self.myStore!) { (isSuccess) in
                if isSuccess{

                    self.indicatorHeight.constant = 50

                    UIView.animate(withDuration: 1) {
                        self.view.layoutIfNeeded()
                        self.closeSign.isHidden = false
                    }

                    
                    userGlobalStores.filter({$0.documentId == self.myStore?.uid}).first?.store?.isClosed = true
                    self.navigationItem.rightBarButtonItems = [self.addBtn,self.openBtn]
                }
            }


        }))
        closeShopPopUP.addAction(UIAlertAction(title: "No", style: .default, handler: { (buttonTapped) in
            closeShopPopUP.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))


        }))
        present(closeShopPopUP, animated: true, completion:  {

            closeShopPopUP.view.superview?.isUserInteractionEnabled = true
            closeShopPopUP.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
        })
    }
    @objc func openShop(){
        StoreServices.instance.openStore(store: myStore!) { (isSuccess) in
            if isSuccess{
                self.indicatorHeight.constant = 0

                UIView.animate(withDuration: 1) {
                    self.view.layoutIfNeeded()
                    self.closeSign.isHidden = true
                }
                userGlobalStores.filter({$0.documentId == self.myStore?.uid}).first?.store?.isClosed = false
                self.navigationItem.rightBarButtonItems = [self.addBtn,self.closeBtn]
            }
        }
            

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
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 100
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        
        if ((product?.isDisabled) == true){
            cell.productName.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.productPrice.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            
            cell.productImage.addSubview(blurEffectView)
        }
        else{
            cell.productName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.productPrice.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            if let blurView = cell.productImage.viewWithTag(100){
                blurView.removeFromSuperview()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        let reactivate = reactivateAction(at: indexPath)
        
        let product = productList[indexPath.row]
        if product.product?.isDisabled == true{
            return UISwipeActionsConfiguration(actions: [edit, reactivate])
        }else{
            return UISwipeActionsConfiguration(actions: [edit, delete])
        }
        
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
                        self.productList[indexPath.row].product?.isDisabled = true
                        self.productList.sort(by: {!($0.product?.isDisabled)! && (($1.product?.isDisabled) != nil)})
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
    func reactivateAction(at indexPath:IndexPath) -> UIContextualAction {
        let done = UIContextualAction(style: .normal, title: "Activate") { (action, view, completion) in
            let selectedProduct = self.productList[indexPath.row]
            StoreServices.instance.reactivateProduct(product: selectedProduct) { (isSuccess) in
                if isSuccess{
                    print("reactivate")
                    self.productList[indexPath.row].product?.isDisabled = false
                    self.productTable.reloadData()
                }
            }

            
        }
        done.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        return done
    }
    
    
}

extension ProductVC:updateProductsDelegate{
    func reloadTable() {
        loadDatas()
    }
    

}

extension ProductVC{
    
    func initLayout(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Products ", attributes: [NSAttributedString.Key.font :UIFont(name: "Roboto-Light", size: 20.0)!,NSMutableAttributedString.Key.foregroundColor: UIColor.white])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        
        
    }
    func loadDatas(){
        StoreServices.instance.listMyStoreProducts(store: myStore!) { (productlist) in
            self.productList = productlist
            self.productList.sort(by: {!($0.product?.isDisabled)! && (($1.product?.isDisabled) != nil)})
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
