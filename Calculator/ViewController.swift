//
//  ViewController.swift
//  Calculator
//
//  Created by Ricardo Herrera Petit on 8/20/16.
//  Copyright © 2016 Ricardo Herrera Petit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false;
    
    @IBAction func touchDigit(sender: UIButton) {
        
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            
            //this is my own elegant solution
            if textCurrentlyInDisplay.rangeOfString(".") == nil || digit != "." {
                display!.text = textCurrentlyInDisplay + digit
            } else
            {
                return
            }
            
            
        }
        else{
            
            if digit == "."
            {
                display.text = "0."
            }
            else {
                display.text = digit
            }
            
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
        historyLabel!.text = brain.description
        /*
        
        if !brain.isCalculatorCleared {
            if(brain.isPartialResult)
            {
                historyLabel!.text = brain.description + "..."
            }
            else
            {
                historyLabel!.text = brain.description + "="
            }
        } else {
            historyLabel!.text = " "
        }
        */
        
        
        
    }
    
}

