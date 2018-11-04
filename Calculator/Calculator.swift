//
//  Calculator.swift
//  Calculator
//
//  Created by misko on 04/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import Foundation

struct Calculator {
    var bufferStringDigitLiteral: String = "0"
    var operands: ArraySlice<Decimal> = [0]
    var operatorr: MathOperator? = nil
    var isNegative: Bool = false
    var isMathError: Bool = false
    
    init() { }
    
    mutating func reset() {
        bufferStringDigitLiteral = "0"
        operands = [0]
        operatorr = nil
        isNegative = false
        isMathError = false
    }
    
    mutating func performMathOperation() {
//        guard let operatorr = operatorr else { return }
//        
//        guard operands.count >= 2 else { return }
        
//        let b = operands[operands.count - 2]
//        let c = operands.last
//        
//        switch operatorr {
//        case .add:
//            return
//        case .sub:
//            return
//        case .mul:
//            return
//        case .div:
//            return
//        }
    }
    
    static func convertValidStringToDecimal(from validString: String) -> Decimal {
        return Decimal(Double(validString)!)
    }
}



enum MathOperator {
    case add, sub, mul, div
}



extension Decimal {
    func rounded(_ scale: Int, mode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var this = self
        NSDecimalRound(&result, &this, scale, mode)
        return result
    }
    
    var isInteger: Bool {
        return self.exponent == 0
    }
}
