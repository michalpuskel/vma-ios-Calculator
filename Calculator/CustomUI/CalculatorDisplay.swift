//
//  CalculatorDisplay.swift
//  Calculator
//
//  Created by misko on 05/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

struct CalculatorDisplay {
    
    static let digitsLimit: Int8 = 9
    
    static func optimalFontSize(for digitsCount: Int8) -> CGFloat {
        switch digitsCount {
        case 9:
            return 52.0
        case 8:
            return 58.0
        case 7:
            return 66.0
        case 6:
            return 78.0
        default:
            return 88.0
        }
    }
    
}
