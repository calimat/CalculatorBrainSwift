//
//  ViewController.swift
//  Calculator
//
//  Created by Ricardo Herrera Petit on 8/20/16.
//  Copyright © 2016 Ricardo Herrera Petit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
   
     var userIsInTheMiddleOfTyping = false;
    
    @IBAction func touchDigit(sender: UIButton) {
        
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display!.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
  
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
       
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
             userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            
        }
        displayValue = brain.result
        
    }

}

