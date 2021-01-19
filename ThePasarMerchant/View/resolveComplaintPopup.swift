//
//  resolveComplaintPopup.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 18/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class resolveComplaintPopup: UIViewController {
    @IBOutlet weak var complaintTable: UITableView!
    
    var complaint:ComplaintDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDatas()
        
        complaintTable.delegate = self
        complaintTable.dataSource = self
        complaintTable.separatorStyle = .none
        complaintTable.sectionHeaderHeight = UITableView.automaticDimension
        complaintTable.estimatedSectionHeaderHeight = 150
        complaintTable.sectionFooterHeight = UITableView.automaticDimension
        complaintTable.estimatedSectionFooterHeight = 200
        complaintTable.register(UINib(nibName: "topComponent", bundle: nil), forCellReuseIdentifier: "topComponent")
        complaintTable.register(UINib(nibName: "middleComponent", bundle: nil), forCellReuseIdentifier: "middleComponent")
        complaintTable.register(UINib(nibName: "bottomComponent", bundle: nil), forCellReuseIdentifier: "bottomComponent")
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
extension resolveComplaintPopup: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topComponent")as? topComponent else {return UITableViewCell()}
        cell.customerName.text = complaint?.complaint?.purchaserName
        cell.receiptNumber.text = complaint?.complaint?.receiptId
        cell.lodgeDate.text = lodgeDateStr(dates: (complaint?.complaint!.date.dateValue())!)
        let address = complaint?.complaint?.purchaserAddress
        let wantedString = address?.components(separatedBy: ", ")
        var add = ""
        
        for word in wantedString!{
            add.append("\(word)\n")
        }
        cell.customerAddress.text = add
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 400
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (complaint?.complaint?.items.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "middleComponent")as? middleComponent else {return UITableViewCell()}
        let item = complaint?.complaint?.items[indexPath.row]
        cell.productName.text = item?.productName
        cell.productCount.text = "\((item?.itemCount)!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bottomComponent")as? bottomComponent else {return UITableViewCell()}
        cell.complaintComment.text = complaint?.complaint?.complaint
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    
}

extension resolveComplaintPopup{
    func loadDatas(){
        print(complaint?.documentId)
    }
    func lodgeDateStr(dates:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateStr = formatter.string(from: dates)
        return dateStr
    }
}
