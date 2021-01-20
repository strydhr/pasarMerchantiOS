//
//  WalkthroughContentVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class WalkthroughContentVC: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    
    var index = 0
    var heading = ""
    var subheading = ""
    var imgStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = heading
        subheaderLabel.text = subheading
        subheaderLabel.numberOfLines = 0
        image.image = UIImage(named: imgStr)
        // Do any additional setup after loading the view.
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
