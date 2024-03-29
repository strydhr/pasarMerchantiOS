//
//  SalesVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 26/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Macaw

class SalesVC: UIViewController {
    //FirtTimer Hints
    @IBOutlet weak var mainHintContainer: UIView!
    @IBOutlet weak var firstHint: UIView!
    @IBOutlet weak var firstBlinky: UIImageView!
    @IBOutlet weak var secondHInt: UIView!
    
    var page = 1
    let defaults = UserDefaults.standard
    //
    
    @IBOutlet weak var salesTable: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var legendCollectView: UICollectionView!
    
    var myStore:Store?
    var productList = [ProductDocument]()
    
    var allSalesList = [Receipts]()
    var salesList = [Receipts]()
    
    var monthlySalesList = [SalesMonth]()
    
    var currentMonthInt = 0
    var currentViewingYear = 0
    
    private let colorPalette = [0xa93226, 0x9b59b6, 0x2980b9, 0x1abc9c, 0x27ae60, 0xf1c40f, 0xe67e22, 0x00ffff, 0xff00ff, 0x34495e]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar.current
        let currentMonth = calendar.dateComponents([.month], from: Date())
        self.currentMonthInt = currentMonth.month!
        loadDatas()
        
        salesTable.delegate = self
        salesTable.dataSource = self
        salesTable.separatorStyle = .none
        salesTable.register(UINib(nibName: "monthlySalesCell", bundle: nil), forCellReuseIdentifier: "monthlySalesCell")
        registeredDateChecker(date: (userGlobal?.registeredDate?.dateValue())!)
        
        print(myStore?.location)
        loadLegend()
        legendCollectView.register(UINib(nibName: "legendCell", bundle: nil), forCellWithReuseIdentifier: "legendCell")
        legendCollectView.delegate = self
        legendCollectView.dataSource = self
        
        mainHintContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
    }
    
    @objc func nextHint(){
        if page == 1{
            firstHint.isHidden = true
            secondHInt.isHidden = false
            page = 2
        }else if page == 2{
            secondHInt.isHidden = true
            mainHintContainer.isHidden = true
            defaults.set(true, forKey: "salesTabHint")
            
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        currentViewingYear += 1
        //        currentViewingYear * (-1)
                loadNextYear(year: currentViewingYear)
    }
    
    @IBAction func previousBtnPressed(_ sender: UIButton) {
        currentViewingYear -= 1
//        currentViewingYear * (-1)
        loadPreviewsYear(year: currentViewingYear)
    }
    
}

extension SalesVC{
    func initLayout(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        let navLabel = UILabel()
//        let navTitle = NSMutableAttributedString(string: "Orders ", attributes: [NSAttributedString.Key.font :UIFont(name: "Helvetica-Neue", size: 20.0)!,NSMutableAttributedString.Key.foregroundColor: UIColor.white])
//
//        navLabel.attributedText = navTitle
        self.navigationItem.title = "Sales"
        
        
        
    }
    func loadDatas(){
        SalesServices.instance.listMySales { (saleslist) in
//            print("total sales count")
            let calendar = Calendar.current
            let today = Date()
            let components = calendar.dateComponents([.year], from: today)
            self.allSalesList = saleslist
            

            let startOfYear = calendar.date(from: components)
            let startOfThisYear = calendar.date(byAdding: DateComponents(year: 0, day: 0), to: startOfYear!)
            self.salesList = self.allSalesList.sorted(by: {$0.date.dateValue().compare($1.date.dateValue()) == .orderedDescending})
            self.salesList = saleslist.filter({$0.date.dateValue() > startOfThisYear!})
            let groupedSales = Dictionary(grouping: self.salesList, by: {calendar.dateComponents([.month], from: $0.date.dateValue()).month})
            for (key,value) in groupedSales{
                let monthStr = Calendar.current.monthSymbols[key! - 1]
                let monthlySales = SalesMonth(Month: key, monthName: monthStr, salesList: value)
                self.monthlySalesList.append(monthlySales)
            }
            
            self.salesTable.reloadData()
            
            self.nextBtn.isEnabled = false
            self.nextBtn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            
        }
    }
    
    func registeredDateChecker(date:Date){
        let calendar = Calendar.current
        let dcomponents = calendar.dateComponents([.year], from: date)

        let today = Date()
        let tcomponents = calendar.dateComponents([.year], from: today)
        yearLabel.text = "\((tcomponents.year)!)"
        
        
        if tcomponents.year! > dcomponents.year!{
            previousBtn.isEnabled = true
        }else{
            previousBtn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            previousBtn.isEnabled = false
        }
        
    }
    
    func loadLegend(){
        StoreServices.instance.listMyStoreProducts(store: myStore!) { (productlist) in
            self.productList = productlist
            self.productList.sort(by: {!($0.product?.isDisabled)! && (($1.product?.isDisabled) != nil)})
            self.legendCollectView.reloadData()
            
            if productlist.count > 0 {
                let isFirstTime = UserDefaults.exist(key: "salesTabHint")
                if isFirstTime == false{
                    self.firstTimeHelper()
                }
            }
        }
    }
    
    func firstTimeHelper(){
        mainHintContainer.isHidden = false
        firstHint.isHidden = false
        secondHInt.isHidden = true
        page = 1
        
        self.firstBlinky.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.firstBlinky.alpha = 1
        } completion: { (success) in
            
        }

    }
    
    func loadPreviewsYear(year:Int){
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year], from: today)
        
        let startOfYear = calendar.date(from: components)
        let startOfxYear = calendar.date(byAdding: DateComponents(year: year, day: 0), to: startOfYear!)
        let endOfXYear = calendar.date(byAdding: DateComponents(year: (year + 1), day: -1), to: startOfYear!)
        
        currentMonthInt = 0
        monthlySalesList.removeAll()
        self.salesList = allSalesList.filter({$0.date.dateValue() > startOfxYear! && $0.date.dateValue() <= endOfXYear!})
        let groupedSales = Dictionary(grouping: self.salesList, by: {calendar.dateComponents([.month], from: $0.date.dateValue()).month})
        for (key,value) in groupedSales{
            let monthStr = Calendar.current.monthSymbols[key! - 1]
            let monthlySales = SalesMonth(Month: key, monthName: monthStr, salesList: value)
            self.monthlySalesList.append(monthlySales)
        }
        
        self.salesTable.reloadData()
        
        nextBtn.isEnabled = true
        nextBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        
        
        let dcomponents = calendar.dateComponents([.year], from: (userGlobal?.registeredDate?.dateValue())!)
        let ccomponents = calendar.dateComponents([.year], from: startOfxYear!)
        yearLabel.text = "\((ccomponents.year)!)"
        if ccomponents.year! > dcomponents.year!{
            previousBtn.isEnabled = true
        }else{
            previousBtn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            previousBtn.isEnabled = false
        }
    }
    
    func loadNextYear(year:Int){
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year], from: today)
        
        let startOfYear = calendar.date(from: components)
        let startOfxYear = calendar.date(byAdding: DateComponents(year: year, day: 0), to: startOfYear!)
        let endOfXYear = calendar.date(byAdding: DateComponents(year: (year + 1), day: -1), to: startOfYear!)
        
        currentMonthInt = 0
        monthlySalesList.removeAll()
        
        let ccomponents = calendar.dateComponents([.year], from: startOfxYear!)
        yearLabel.text = "\((ccomponents.year)!)"
        previousBtn.isEnabled = true
        previousBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        
        if ccomponents.year == components.year{
            let currentMonth = calendar.dateComponents([.month], from: Date())
            self.currentMonthInt = currentMonth.month!
            nextBtn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            nextBtn.isEnabled = false
        }
        
        
        self.salesList = allSalesList.filter({$0.date.dateValue() > startOfxYear! && $0.date.dateValue() <= endOfXYear!})
        let groupedSales = Dictionary(grouping: self.salesList, by: {calendar.dateComponents([.month], from: $0.date.dateValue()).month})
        for (key,value) in groupedSales{
            let monthStr = Calendar.current.monthSymbols[key! - 1]
            let monthlySales = SalesMonth(Month: key, monthName: monthStr, salesList: value)
            self.monthlySalesList.append(monthlySales)
        }
        
        self.salesTable.reloadData()
    }
}

extension SalesVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "legendCell", for: indexPath)as? legendCell else {return UICollectionViewCell()}
        let product = productList[indexPath.row]
        let color = colorPalette[product.product!.colorClass]
        
        cell.productColor.backgroundColor = UIColor(rgb: color)
        cell.productLabel.text = product.product?.name
        if product.product?.isDisabled == true{
            cell.productLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 50)
    }
    
}

extension SalesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentMonthInt != 0{
            return currentMonthInt
        }else{
            return 12
        }
//        return monthlySalesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "monthlySalesCell")as? monthlySalesCell else {return UITableViewCell()}
        if let test =  monthlySalesList.firstIndex(where: {$0.Month == (indexPath.row + 1)}){
            let sales = monthlySalesList[test]
            cell.monthLabel.text = sales.monthName
            var totalSales:Double = 0
            for item in sales.salesList!{
                var subtotal:Double = 0
                for items in item.items{
                    subtotal += items.productPrice * Double(items.itemCount)
                }
                totalSales += subtotal
            }
            //

            var arrayOfProduct = [itemPurchasing]()
            for item in sales.salesList!{
                arrayOfProduct.append(contentsOf: item.items)

            }
            let groupItem = Dictionary(grouping: arrayOfProduct, by: {$0.productName})
            var arrayOfGroupedProduct = [GroupedProduct]()
            for (key,value) in groupItem{
                var total = 0
                var colorClass = 0
                for item in value{
                    total += item.itemCount
                    colorClass = item.colorClass
                }
                let groupedProduct = GroupedProduct(ProductName: key, totalSales: total, colorClass: colorClass)
                arrayOfGroupedProduct.append(groupedProduct)
            }
            let maxCount = arrayOfGroupedProduct.max(by: {$1.totalSales > $0.totalSales})?.totalSales
            //
//            print(maxCount)
            cell.barCounts = arrayOfGroupedProduct.count
            cell.maxProductCount = maxCount
            cell.barsValues = arrayOfGroupedProduct
            cell.totalAmountLabel.text = "RM \(String(format: "%.2f", totalSales))"
            cell.play(withDelay: 0.5)
            cell.pieChart.isHidden = false
        }
        
            
            
        else{
            let monthStr = Calendar.current.monthSymbols[indexPath.row]
            cell.monthLabel.text = monthStr
            cell.totalAmountLabel.text = "RM 0"
            cell.pieLabel = ""
            cell.pieChart.isHidden = true
//            cell.pieChart.word = " "
        }
        
          
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let test =  monthlySalesList.firstIndex(where: {$0.Month == (indexPath.row + 1)}){
            let sales = monthlySalesList[test]
            return 270
        }else{
            return 60
        }
    }
    
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
