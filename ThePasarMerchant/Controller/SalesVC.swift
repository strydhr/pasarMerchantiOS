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
    
    var allSalesList = [Receipts]()
    var salesList = [Receipts]()
    
    var monthlySalesList = [SalesMonth]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        
        salesTable.delegate = self
        salesTable.dataSource = self
        salesTable.separatorStyle = .none
        salesTable.register(UINib(nibName: "monthlySalesCell", bundle: nil), forCellReuseIdentifier: "monthlySalesCell")
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
}

extension SalesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlySalesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "monthlySalesCell")as? monthlySalesCell else {return UITableViewCell()}
        let sales = monthlySalesList[indexPath.row]
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
          
        
        return cell
    }
    
    
}
