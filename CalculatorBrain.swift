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
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
   private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "±": Operation.UnaryOperation({-$0}),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation( { $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
  private  enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]
        {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation (let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstoperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
        
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
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