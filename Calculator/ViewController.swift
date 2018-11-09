//
//  ViewController.swift
//  Calculator
//
//  Created by misko on 02/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var calculator: Calculator!
    @IBOutlet weak var display: UILabel!
    
    var mathOperatorTyped: Bool! = false
    var ResultTyped: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIForNoIPhone4()
        
        calculator = Calculator(with: display)
    }
    
    @IBAction func onDigitTapped(_ sender: UIButton) {
        guard !calculator.isMathError else {
            calculator.bufferedStringNumberLiteral = "Chyba"
            return
        }
        
        guard sender.currentTitle! != "0" || !calculator.bufferedStringNumberLiteral.isEmpty else { return }
        
        guard calculator.bufferedDigitsCount < CalculatorDisplay.digitsLimit else { return }
        
        mathOperatorTyped = false
        
        print("\n ####### \(calculator.bufferedDigitsCount) \n")
        
        if calculator.bufferedDigitsCount > 0 {
            calculator.bufferedStringNumberLiteral += sender.currentTitle!
        } else {
            calculator.bufferedStringNumberLiteral = sender.currentTitle!
        }
        
    }
    
    @IBAction func onCommaTapped(_ sender: UIButton) {
        guard !calculator.isMathError else {
            calculator.bufferedStringNumberLiteral = "Chyba"
            return
        }
        
        guard !calculator.commaTyped else { return }
        
        guard calculator.number.isInteger else { return }
        
        guard calculator.bufferedDigitsCount < CalculatorDisplay.digitsLimit else { return }
        
        if calculator.bufferedStringNumberLiteral.isEmpty {
            calculator.bufferedStringNumberLiteral = "0"
        } else if calculator.bufferedDigitsCount == 0 {
            return
        }
        
        calculator.commaTyped = true
        calculator.bufferedStringNumberLiteral += sender.currentTitle!
    }
    
    @IBAction func onAllClearTapped(_ sender: UIButton) {
        ResultTyped = false
        mathOperatorTyped = false
        calculator.reset(saveAndDisplay: nil)
        
        print("number: \(calculator.number)")
        print("operands: \(calculator.operands)")
        print("operators: \(calculator.operatorrs)")
    }
    
    @IBAction func onMathOperationTapped(_ sender: UIButton) {
        guard !calculator.isMathError else {
            calculator.bufferedStringNumberLiteral = "Chyba"
            return
        }
        
        let mathOperator: MathOperator?
        switch sender.currentTitle {
        case "+":
            mathOperator = .add
        case "−":
            mathOperator = .sub
        case "×":
            mathOperator = .mul
        case "÷":
            mathOperator = .div
        default:
            print("Unkown math operator: this error could not have ever happend!")
            mathOperator = nil
        }
        
        guard !mathOperatorTyped else {
            if !calculator.operatorrs.isEmpty {
                calculator.operatorrs[calculator.operatorrs.startIndex + calculator.operatorrs.count - 1] = mathOperator!
            }
            return
        }
        mathOperatorTyped = true
        
        calculator.operatorrs.append(mathOperator!)
        
        if !calculator.operatorrs.isEmpty && calculator.bufferedDigitsCount > 0 {
            if ResultTyped && !calculator.operands.isEmpty {
                calculator.operands[calculator.operands.startIndex] = calculator.number
                ResultTyped = false
            } else {
                calculator.operands.append(calculator.number)
            }
        }
        
        
        
        
        print()
        print("number: \(calculator.number)")
        print("operands: \(calculator.operands)")
        print("operators: \(calculator.operatorrs)")
        
        if let result = calculator.performMathOperation() {
            print("VYRATAL")
            calculator.resetNumber(andDisplay: String(describing: result).replacingOccurrences(of: ".", with: ","))
        } else {
            print("nevyratal")
            calculator.resetNumber(andDisplay: calculator.bufferedStringNumberLiteral)
        }
    }
    
    
    @IBAction func onResultTapped(_ sender: UIButton) {
        guard !calculator.isMathError else {
            calculator.bufferedStringNumberLiteral = "Chyba"
            return
        }
        
        guard !calculator.operatorrs.isEmpty else { return }
        
        if calculator.bufferedDigitsCount > 0 {
             calculator.operands.append(calculator.number)
        }
        
        guard calculator.operands.count >= 2 else { return }
        
        print()
        print("number: \(calculator.number)")
        print("operands: \(calculator.operands)")
        print("operators: \(calculator.operatorrs)")
        
        let result = calculator.performMathOperation()
        if calculator.isMathError {
            calculator.bufferedStringNumberLiteral = "Chyba"
        } else {
            calculator.reset(saveAndDisplay: result)
        }
        ResultTyped = true

        print(calculator.bufferedDigitsCount)
        print(" result \(String(describing: result))")
        
        
        print()
        print("number: \(calculator.number)")
        print("operands: \(calculator.operands)")
        print("operators: \(calculator.operatorrs)")
    }
    
    private func setUIForNoIPhone4 () {
        if UIScreen.main.bounds.size.height >= 500 {
            for constraint in self.view.constraints {
                if constraint.identifier == "bigScreenConstraint" {
                    constraint.constant = 10
                }
            }
            self.view.layoutIfNeeded()
        }
    }

}

