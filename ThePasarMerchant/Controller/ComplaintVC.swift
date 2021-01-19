//
//  ComplaintVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 18/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class ComplaintVC: UIViewController {
    @IBOutlet weak var complaintTable: UITableView!
    
    var complaintList = [ComplaintDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        
        complaintTable.delegate = self
        complaintTable.dataSource = self
        complaintTable.separatorStyle = .none
        complaintTable.register(UINib(nibName: "complaintCell", bundle: nil), forCellReuseIdentifier: "complaintCell")

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
extension ComplaintVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaintList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "complaintCell")as? complaintCell else {return UITableViewCell()}
        let complaint = complaintList[indexPath.row]
        cell.deliveryDateLabel.text = getDateLabel(dates: (complaint.complaint?.deliveryTime.dateValue())!)
        var totalItems = 0
        for item in complaint.complaint!.items{
            totalItems += item.itemCount
        }
        cell.camplaintOrdersLabel.text = "Number of Orders: \(totalItems)"
        cell.dateLabel.text = lodgeDateStr(dates: (complaint.complaint?.date.dateValue())!)
        
        let address = complaint.complaint?.purchaserAddress
        let wantedString = address?.components(separatedBy: ", ")
        var add = ""
        
        for word in wantedString!{
            add.append("\(word)\n")
        }
        cell.deliveryAddressLabel.text = add
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedComplaint = complaintList[indexPath.row]
        let complaintPopup = resolveComplaintPopup()
        complaintPopup.complaint = selectedComplaint
        complaintPopup.delegate = self
        present(complaintPopup, animated: true, completion: nil)

    }
    
    
    
}

extension ComplaintVC:updateComplaintTableDelegate{
    func didupdate(status: Bool, item: ComplaintDocument) {
        if status{
            if let index = complaintList.firstIndex(where: {$0.documentId == item.documentId}){
                complaintList.remove(at: index)
                complaintTable.reloadData()
            }
        }
    }
    

    
    func loadDatas(){
        ComplaintServices.instance.listMyComplaint { (complaintlist) in
            self.complaintList = complaintlist.sorted(by: {$0.complaint!.date.dateValue().compare($1.complaint!.date.dateValue()) == .orderedDescending})
            self.complaintTable.reloadData()
        }
    }
    
    func lodgeDateStr(dates:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateStr = formatter.string(from: dates)
        return dateStr
    }
}
