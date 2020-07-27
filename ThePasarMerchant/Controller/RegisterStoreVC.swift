//
//  RegisterStoreVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 27/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class RegisterStoreVC: UIViewController {
    @IBOutlet weak var editTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editTable.delegate = self
        editTable.dataSource = self
        editTable.separatorStyle = .none
        editTable.register(UINib(nibName: "registerStoreCell", bundle: nil), forCellReuseIdentifier: "registerStoreCell")
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

extension RegisterStoreVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "registerStoreCell")as? registerStoreCell else {return UITableViewCell()}
        switch indexPath.row {
        case 0:
            cell.editTF.attributedPlaceholder = NSAttributedString(string: "Name")
        case 1:
            cell.editTF.attributedPlaceholder = NSAttributedString(string: "Type")
        case 2:
            cell.editTF.attributedPlaceholder = NSAttributedString(string: "Location")
        default:
            cell.editTF.attributedPlaceholder = NSAttributedString(string: "Image")
        }
        
        return cell
    }
    
    
}
