//
//  BigScreenConstraint.swift
//  Calculator
//
//  Created by misko on 03/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class BigScreenConstraint: NSLayoutConstraint {

    override var constant: CGFloat = 66
    
    override init() {
        
        print("init")
        super.init()
        
    }
    
}
