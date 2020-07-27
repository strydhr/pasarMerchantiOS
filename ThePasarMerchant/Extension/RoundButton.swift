//
//  RoundButton.swift
//  Workout
//
//  Created by Satyia Anand on 19/12/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
