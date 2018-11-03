//
//  RoundButton.swift
//  Calculator
//
//  Created by misko on 02/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        layer.masksToBounds = true
        switch UIScreen.main.bounds.size.height {
        case 0...500:
            layer.cornerRadius = 30.0
        case 501...600:
            layer.cornerRadius = 34.0
        default:
            layer.cornerRadius = self.frame.height / 2.0
        }
    }
    
}
