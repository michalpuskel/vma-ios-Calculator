//
//  CalculatorDisplay.swift
//  Calculator
//
//  Created by misko on 05/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

struct CalculatorDisplay {
    
    static func optimalFontSize(for digitsCount: Int8) -> CGFloat {
        switch digitsCount {
        case 9:
            return 55.0
        case 8:
            return 60.0
        case 7:
            return 70.0
        case 6:
            return 83.0
        default:
            return 88.0
        }
    }
    
}
