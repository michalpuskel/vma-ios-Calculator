//
//  Calculator.swift
//  Calculator
//
//  Created by misko on 04/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class Calculator {
    var operands: [Decimal] = []
    var operatorrs: [MathOperator] = []
    var isNegative: Bool = false
    var isMathError: Bool = false
    
    var bufferedStringNumberLiteral: String = "" {
        willSet {
            if let newChar = newValue.last {
                if newChar != "," && newChar != "a" {
                    bufferedDigitsCount += 1
                }
            }
        }
        didSet {
            let desiredFontSize = CalculatorDisplay.optimalFontSize(for: max(bufferedDigitsCount, Int8(String(describing: number).count)))
            if display.font.pointSize != desiredFontSize {
                display.font = UIFont.systemFont(ofSize: desiredFontSize, weight: .thin)
            }
            
            guard !bufferedStringNumberLiteral.isEmpty else {
                display.text = "0"
                return
            }
            
            display.text = bufferedStringNumberLiteral
        }
    }
    var number: Decimal {
        guard !isMathError else { return 0.0 }
        
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
    
    func reset(saveAndDisplay result: Decimal? = 0.0) {
        if let result = result {
            operands = [result]
            if result == 0.0 {
                resetNumber()
            } else {
                resetNumber(andDisplay: String(describing: result).replacingOccurrences(of: ".", with: ","))
            }
        } else {
            operands = []
            resetNumber()
        }
        operatorrs = []
        isNegative = false
        isMathError = false
    }
    
    func resetNumber(andDisplay result: String = "") {
        bufferedStringNumberLiteral = result
        bufferedDigitsCount = 0
        commaTyped = false
    }
    
    func performMathOperation() -> Decimal? {
        guard !isMathError else { print("todo math err"); return nil }
        
        guard operands.count >= 2 else { print("zbieram operandy"); return nil }
        
        let a, b, c: Decimal?
        let op1, op2: MathOperator?
        
        a = operands.count >= 1 ? operands[operands.startIndex] : nil
        b = operands.count >= 2 ? operands[operands.startIndex + 1] : nil
        c = operands.count >= 3 ? operands[operands.startIndex + 2] : nil
        op1 = operatorrs.count >= 1 ? operatorrs[operatorrs.startIndex] : nil
        op2 = operatorrs.count >= 2 ? operatorrs[operatorrs.startIndex + 1] : nil
        
        switch operatorrs.count {
        case 1:
            if let tmpResult = calculate(number1: a!, op1!, number2: b!) {
                return tmpResult
            } else {
                return nil
            }
        case 2:
            if [.mul, .div].contains(op1!) || [.add, .sub].contains(op2!) {
                if let tmpResult = calculate(number1: a!, op1!, number2: b!) {
                    operands.removeLast(2)
                    operands.append(tmpResult)
                    operatorrs.removeFirst()
                    return tmpResult
                } else {
                    return nil
                }
            } else if [.mul, .div].contains(op2!) && operands.count == 3 {
                if let tmpResult = calculate(number1: b!, op2!, number2: c!) {
                    operands.removeLast(2)
                    operands.append(tmpResult)
                    operatorrs.remove(at: operatorrs.startIndex + 1)
                    let finalResult = performMathOperation()
                    return finalResult
                } else {
                    return nil
                }
            } else {
                return nil
            }
        case 3:
            if [.mul, .div].contains(op2!) {
                if let tmpResult = calculate(number1: b!, op2!, number2: c!) {
                    operands.remove(at: operands.startIndex + 1)
                    operands.remove(at: operands.startIndex + 1)
                    operands.insert(tmpResult, at: operands.startIndex + 1)
                    operatorrs.remove(at: operatorrs.startIndex + 1)
                    return tmpResult
                } else {
                    return nil
                }
            } else {
                print("fatal impossible error")
                return nil
            }
        default:
            print("#op: \(operatorrs.count)")
            return nil
        }
    }
    
    private func calculate(number1 operand1: Decimal, _ operatorr: MathOperator, number2 operand2:Decimal) -> Decimal? {
        let result: Decimal?
        switch operatorr {
        case .add:
            result = operand1 + operand2
        case .sub:
            result =  operand1 - operand2
        case .mul:
            result =  operand1 * operand2
        case .div:
            guard operatorr != .div || operand2 != 0.0 else {
                isMathError = true
                bufferedStringNumberLiteral = "Chyba"
                return nil
            }
            
            result =  operand1 / operand2
        }
        return result?.rounded(9, mode: .plain)
    }
    
    private func convertValidStringToDecimal(from validString: String) -> Decimal {
        let precisionMultiplierDouble: Double = 100_000_000_000.0
        let precisionMultiplierDecimal: Decimal = 100_000_000_000.0
        let resultDouble = Double(validString)! * precisionMultiplierDouble
        let resultDecimal = Decimal(resultDouble) / precisionMultiplierDecimal
        
        return resultDecimal.rounded(10, mode: .plain)
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

