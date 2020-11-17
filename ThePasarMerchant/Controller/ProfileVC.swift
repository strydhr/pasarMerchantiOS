//
//  ProfileVC.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 11/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    @IBOutlet weak var profileTable: UITableView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTable.delegate = self
        profileTable.dataSource = self
        profileTable.separatorStyle = .none
        profileTable.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    }
    

    @objc func backgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerStoreSegue"{
            let destination = segue.destination as! RegisterStoreVC
            destination.delegate = self
            destination.fromMain = false
        }
    }

}
extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return userGlobalStores.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")as? profileCell else {return UITableViewCell()}
        if section == 0{
            cell.contentLabel.text = userGlobal?.name
        }else if section == 1{
            cell.contentLabel.text = "\((userGlobal?.storeCount)!) Stores"
            cell.editBtn.isHidden = false
            cell.delegate = self
        }else if section == 2{
            cell.contentLabel.text = "Enable Hints"
        }else if section == 3{
            cell.contentLabel.text = "Log Out"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")as? profileCell else {return UITableViewCell()}
        if indexPath.section == 1{
            let store = userGlobalStores[indexPath.row]

            cell.contentLabel.text = store.store?.name
//            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.containerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
//        else if indexPath.row == 1{
//            cell.contentLabel.text = "\((userGlobal?.storeCount)!) Stores"
//            cell.editBtn.isHidden = false
////            cell.delegate = self
//        }else if indexPath.row == 2{
//            cell.contentLabel.text = "Enable Hints"
//        }else if indexPath.row == 3{
//            cell.contentLabel.text = "Log Out"
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 2:
            let domain = Bundle.main.bundleIdentifier
            defaults.removePersistentDomain(forName: domain!)
            defaults.synchronize()
//            UserDefaults.clear()
        case 3:
            let logOutPopUP = UIAlertController(title: "Logout?", message: "Are you sure you want to log out?", preferredStyle: .alert)
            logOutPopUP.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (buttonTapped) in
                do{
                    try Auth.auth().signOut()
                    let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "initialVC")
                    //probelm logging out then sign new acc
                    userGlobal = nil

                    //
                    initialVC?.modalPresentationStyle = .fullScreen
                    self.present(initialVC!, animated: true, completion: nil)
                } catch{
                    print(error)

                }


            }))
            present(logOutPopUP, animated: true, completion:  {

                logOutPopUP.view.superview?.isUserInteractionEnabled = true
                logOutPopUP.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
            })
        default:
            print("None")
        }
    }
    
}

extension ProfileVC:editProfileDetailsDelegate,hasStoreDelegate{
    func hasStore(status: Bool) {
        profileTable.reloadData()
    }
    
    func editDetails(user: Merchant) {
        performSegue(withIdentifier: "registerStoreSegue", sender: self)
    }
    
    func updatedProfile(user: User) {
        profileTable.reloadData()
    }
    
    
}

extension UserDefaults{
    class func clear(){
        guard let domain = Bundle.main.bundleIdentifier else {return}
        standard.removePersistentDomain(forName: domain)
        standard.synchronize()
    }
    
    class func exist(key:String)->Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
