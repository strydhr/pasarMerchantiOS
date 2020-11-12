//
//  multipleStoreSelection.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 12/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class multipleStoreSelection: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var storeTable: UITableView!
    
    var storeList:[Store]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeTable.register(UINib(nibName: "storeCell", bundle: nil), forCellReuseIdentifier: "storeCell")
        storeTable.delegate = self
        storeTable.dataSource = self
    }




}
extension multipleStoreSelection: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell")as? storeCell else {return UITableViewCell()}
        let store = storeList![indexPath.row]
        cell.storeImage.cacheImage(imageUrl: store.profileImage)
        cell.storeLabel.text = store.name
        cell.storeType.text = store.type
        
        cell.storeAddress.numberOfLines = 0
        cell.storeAddress.text = store.location
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = storeList![indexPath.row]
//        selectedStore = store
//        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "viewProductSegue", sender: self)
    }
    
    
}
