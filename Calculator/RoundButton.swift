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
        layer.cornerRadius = self.frame.height / 2.0
    }
    
}
