//
//  ViewController.swift
//  Calculator
//
//  Created by misko on 02/11/2018.
//  Copyright © 2018 FMFI UK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUIForNoIPhone4()
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

