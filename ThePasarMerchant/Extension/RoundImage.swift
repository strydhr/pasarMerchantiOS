//
//  RoundImage.swift
//  Workout
//
//  Created by Satyia Anand on 19/12/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}



class RoundMarker: UIImageView {
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
