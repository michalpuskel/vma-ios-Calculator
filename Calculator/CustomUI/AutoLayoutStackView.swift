//
//  AutoLayoutStackView.swift
//  Calculator
//
//  Created by misko on 03/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class AutoLayoutStackView: UIStackView {

    override func awakeFromNib() {
        setUIForNoIPhone4()
    }
    
    private func setUIForNoIPhone4 () {
        if UIScreen.main.bounds.size.height >= 500 {
            self.spacing = 10
            self.layoutIfNeeded()
        }
    }

}
