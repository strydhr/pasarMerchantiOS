//
//  monthlySalesCell.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 26/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Macaw

class monthlySalesCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var pieChart: PieChart!
    
    var pieLabel:String?
    var barsValues:[GroupedProduct]?
    var barCounts:Int?
    var barCaptions:[String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pieChart.contentMode = .scaleAspectFit
        
        
    }
    
    func play(withDelay: TimeInterval) {
        for item in barsValues!{
            barCaptions?.append(item.ProductName!)
        }
        pieChart.barsValues = barsValues!
        let count = barsValues?.count
        pieChart.barsCount = count!
//        pieChart.barsCaptions = barCaptions!
        
        self.perform(#selector(animateViews), with: .none, afterDelay: withDelay)
    }
    
    @objc open func animateViews() {
        pieChart.play()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
