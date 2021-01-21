//
//  itemizePopup.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 21/01/2021.
//  Copyright © 2021 Satyia Anand. All rights reserved.
//

import UIKit

class itemizePopup: UIViewController {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var salesTable: UITableView!
    
    var receipt:Receipts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        salesTable.delegate = self
        salesTable.dataSource = self
        salesTable.separatorStyle = .none
        salesTable.register(UINib(nibName: "salesItemCell", bundle: nil), forCellReuseIdentifier: "salesItemCell")
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundtapped)))
    }


    @objc func backgroundtapped(){
        dismiss(animated: true, completion: nil)
    }

}
extension itemizePopup:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (receipt?.items.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "salesItemCell")as? salesItemCell else {return UITableViewCell()}
        let item = receipt?.items[indexPath.row]
        cell.configureCell(item: item!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
