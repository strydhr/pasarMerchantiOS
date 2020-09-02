//
//  SalesVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 26/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class SalesVC: UIViewController {
    @IBOutlet weak var salesTable: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var allSalesList = [Receipts]()
    var salesList = [Receipts]()
    
    var monthlySalesList = [SalesMonth]()
    
    var currentMonthInt = 0
    var currentViewingYear = 0
    
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
        print(currentViewingYear)
    }
    
}

extension SalesVC{
    func loadDatas(){
        SalesServices.instance.listMySales { (saleslist) in
            print("total sales count")
            print(saleslist.count)
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
        print(allSalesList.count)
        print(salesList.count)
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
            print("hello")
            print(currentMonthInt)
            nextBtn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            nextBtn.isEnabled = false
        }
        
        
        self.salesList = allSalesList.filter({$0.date.dateValue() > startOfxYear! && $0.date.dateValue() <= endOfXYear!})
        print(salesList.count)
        let groupedSales = Dictionary(grouping: self.salesList, by: {calendar.dateComponents([.month], from: $0.date.dateValue()).month})
        for (key,value) in groupedSales{
            let monthStr = Calendar.current.monthSymbols[key! - 1]
            let monthlySales = SalesMonth(Month: key, monthName: monthStr, salesList: value)
            self.monthlySalesList.append(monthlySales)
        }
        
        self.salesTable.reloadData()
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
            cell.totalAmountLabel.text = "RM \(String(format: "%.2f", totalSales))"
        }
        
            
            
        else{
            let monthStr = Calendar.current.monthSymbols[indexPath.row]
            cell.monthLabel.text = monthStr
            cell.totalAmountLabel.text = "RM 0"
        }
        
          
        
        return cell
    }
    
    
}
