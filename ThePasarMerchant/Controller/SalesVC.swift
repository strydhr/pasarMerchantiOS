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
    }
    
    @IBAction func previousBtnPressed(_ sender: UIButton) {
    }
    
}

extension SalesVC{
    func loadDatas(){
        SalesServices.instance.listMySales { (saleslist) in
            print(saleslist.count)
            let calendar = Calendar.current
            let today = Date()
            let components = calendar.dateComponents([.year], from: today)
            
            

            let startOfYear = calendar.date(from: components)
            let startOfThisYear = calendar.date(byAdding: DateComponents(year: 0, day: 0), to: startOfYear!)
            print(startOfThisYear)
            self.salesList = self.salesList.sorted(by: {$0.date.dateValue().compare($1.date.dateValue()) == .orderedDescending})
            self.salesList = saleslist.filter({$0.date.dateValue() > startOfThisYear!})
            let groupedSales = Dictionary(grouping: self.salesList, by: {calendar.dateComponents([.month], from: $0.date.dateValue()).month})
            for (key,value) in groupedSales{
                let monthStr = Calendar.current.monthSymbols[key! - 1]
                let monthlySales = SalesMonth(Month: key, monthName: monthStr, salesList: value)
                self.monthlySalesList.append(monthlySales)
            }
            
            self.salesTable.reloadData()
            
        }
    }
    
    func registeredDateChecker(date:Date){
        let calendar = Calendar.current
        let dcomponents = calendar.dateComponents([.year], from: date)

        let today = Date()
        let tcomponents = calendar.dateComponents([.year], from: today)
        let startOfYear = calendar.date(from: tcomponents)
        
        if tcomponents.year! > dcomponents.year!{
            previousBtn.isEnabled = true
        }else{
            previousBtn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            previousBtn.isEnabled = false
        }
        
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
