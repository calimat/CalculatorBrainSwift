//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ricardo Herrera Petit on 8/21/16.
//  Copyright © 2016 Ricardo Herrera Petit. All rights reserved.
//

import Foundation



class CalculatorBrain {
    
    
    
    private var accumulator = 0.0
    
    var description = " "
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        
    }
    
    
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "±": Operation.UnaryOperation({-$0}),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "abs": Operation.UnaryOperation(abs),
        "×": Operation.BinaryOperation( { $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    
    
    
    
    var isPartialResult: Bool {
        return pending != nil ? true : false
    }
    
    private  enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    var isAddingToHistoryDescription = true
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]
        {
            switch operation {
            case .Constant(let value):
                
                accumulator = value
                
            case .UnaryOperation (let function):
                if isPartialResult
                {
                    description += symbol + String(accumulator)
                    isAddingToHistoryDescription = false
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstoperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                
                
                
            }
           
            if isPartialResult && isAddingToHistoryDescription
            {
                description += String(accumulator)
                description += symbol
                
            } else {
                
                if symbol != "=" && isAddingToHistoryDescription
                {
                     description =  symbol + "(" + description + ")"
                }
               
            }
           
           
        }
        
    }
    
    
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            if isAddingToHistoryDescription
            {
                description += String(accumulator)
            }
            
            
            accumulator = pending!.binaryFunction(pending!.firstoperand, accumulator)
            pending = nil
        }
        
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo
    {
        var binaryFunction: (Double,Double) -> Double
        var firstoperand: Double
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
    
}