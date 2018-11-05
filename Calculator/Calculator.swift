//
//  Calculator.swift
//  Calculator
//
//  Created by misko on 04/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class Calculator {
    var operands: [Decimal] = [0.0]
    var operatorrs: [MathOperator] = []
    var isNegative: Bool = false
    var isMathError: Bool = false
    
    var bufferedStringNumberLiteral: String = "" {
        willSet {
            if let newChar = newValue.last {
                if newChar != "," {
                    bufferedDigitsCount += 1
                }
            }
        }
        didSet {
            guard !bufferedStringNumberLiteral.isEmpty else {
                resetNumber()
                display.text = "0"
                return
            }
            
            display.text = number.formattedWithSeparator
            print(number)
            if number.isInteger && commaTyped {
                display.text = display.text! + ","
            }
            let desiredFontSize = CalculatorDisplay.optimalFontSize(for: bufferedDigitsCount)
            if display.font.pointSize != desiredFontSize {
                display.font = display.font.withSize(desiredFontSize)
            }
        }
    }
    var number: Decimal {
        guard !bufferedStringNumberLiteral.isEmpty else { return 0.0 }
        
        var validString = bufferedStringNumberLiteral
        if let lastChar = validString.last {
            if lastChar == "," {
                validString.removeLast()
            }
        }
        return convertValidStringToDecimal(from: validString.replacingOccurrences(of: ",", with: "."))
    }
    var bufferedDigitsCount: Int8 = 0
    var commaTyped: Bool = false
    let display: UILabel
    
    init(with display: UILabel) {
        self.display = display
    }
    
    func reset() {
        operands = [0.0]
        operatorrs = []
        isNegative = false
        isMathError = false
        bufferedStringNumberLiteral = ""
    }
    
    func resetNumber() {
        bufferedDigitsCount = 0
        commaTyped = false
    }
    
    func performMathOperation() -> Decimal? {
        guard !isMathError else { print("todo math err"); return nil }
        
        guard operands.count >= 2 else { print("todo operands err"); return nil }
        
        guard !operatorrs.isEmpty else { print("todo operators err"); return nil }
        
        let c = operands.last!
        let operatorr = operatorrs.last!
        
        guard c != 0.0 || operatorr != .div else {
            isMathError = true
            return nil
        }
        
        let b = operands[operands.startIndex + operands.count - 2]
            
        switch operatorr {
        case .add, .sub:
            guard operands.count == 3 else {
                return calculate(number1: b, operatorr, number2: c)
            }
            
            let a = operands.first!
            let tmpResult = calculate(number1: a, operatorrs.first!, number2: b)
            operands.removeFirst(2)
            operands.insert(tmpResult, at: operands.startIndex)
            operatorrs.removeFirst()
            
            return calculate(number1: tmpResult, operatorr, number2: c)
        case .mul, .div:
            let tmpResult = calculate(number1: b, operatorr, number2: c)
            operands.removeLast(2)
            operands.append(tmpResult)
            operatorrs.removeLast()
            
            guard operands.count == 3 else {
                return tmpResult
            }
            
            let a = operands.first!
            return calculate(number1: a, operatorrs.first!, number2: tmpResult)
        }
    }
    
    private func calculate(number1 operand1: Decimal, _ operatorr: MathOperator, number2 operand2:Decimal) -> Decimal {
        switch operatorr {
        case .add:
            return operand1 + operand2
        case .sub:
            return operand1 - operand2
        case .mul:
            return operand1 * operand2
        case .div:
            return operand1 / operand2
        }
    }
    
    private func convertValidStringToDecimal(from validString: String) -> Decimal {
        let precisionMultiplierDouble: Double = 1_000_000_000.0
        let precisionMultiplierDecimal: Decimal = 1_000_000_000.0
        let resultDouble = Double(validString)! * precisionMultiplierDouble
        let resultDecimal = Decimal(resultDouble) / precisionMultiplierDecimal
        
        return resultDecimal
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
    
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}



extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

