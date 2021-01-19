//
//  resolveComplaintPopup.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 18/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

protocol updateComplaintTableDelegate {
    func didupdate(status:Bool,item:ComplaintDocument)
}

class resolveComplaintPopup: UIViewController {
    @IBOutlet weak var complaintTable: UITableView!
    
    var delegate:updateComplaintTableDelegate?
    var complaint:ComplaintDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        cell.customerAddressLabel.numberOfLines = 0
        cell.customerAddressLabel.sizeToFit()
        
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
        cell.delegate = self
        cell.complaint = complaint
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    
}

extension resolveComplaintPopup:resolveComplaintDelegate{
    func resolveComplaint(item: ComplaintDocument) {
        let resolveActionPopup = UIAlertController(title: "Resolve Complaint", message: "Have you resolved customer compplaint", preferredStyle: .alert)
        resolveActionPopup.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (buttonTapped) in
            ComplaintServices.instance.resolveComplaint(complaint: item) { (isSuccess) in
                if isSuccess{
                    self.delegate?.didupdate(status: true,item:self.complaint!)
                    self.dismiss(animated: true, completion: nil)
                }
            }


        }))
        resolveActionPopup.addAction(UIAlertAction(title: "No,Whatsapp Customer Now", style: .default, handler: { (buttonTapped) in
            let urlWhats = "https://wa.me/\((self.complaint?.complaint?.purchaserPhone)!)"
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(whatsappURL)
                        }
                    }
                    else {
                        let alert = UIAlertController(title: "WhatsApp Error", message: "You require the app WhatsApp to continue", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
//            self.dismiss(animated: true, completion: nil)


        }))
        present(resolveActionPopup, animated: true, completion:  nil)
        

    }

    func lodgeDateStr(dates:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateStr = formatter.string(from: dates)
        return dateStr
    }
}
