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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIForNoIPhone4()
        
        calculator = Calculator(with: display)
    }
    
    @IBAction func onDigitTapped(_ sender: UIButton) {
        calculator.bufferedStringNumberLiteral += sender.currentTitle!
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

