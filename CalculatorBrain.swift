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
    
    private var secondAccumulator = 0.0
    
    private var appendedThreePoints = false
    
    private var maximumNumberofOperands = 3
    
    var description: String
        {
        get {
            
            if isPartialResult
            {
                if sequenceHistoryArray.count < maximumNumberofOperands
                {
                sequenceHistoryArray.append("...")
                appendedThreePoints = true
                }
                
            }
            
            if appendedThreePoints && !isPartialResult
            {
                if sequenceHistoryArray.indexOf("...") != nil{
                     sequenceHistoryArray.removeAtIndex(sequenceHistoryArray.indexOf("...")!)
                }
               
            }
           
            if sequenceHistoryArray.count > 0
            {
                return sequenceHistoryArray.joinWithSeparator("")
            }
            return " "
        }
        
    }
    
    var sequenceHistoryArray =  [String]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        sequenceHistoryArray.append(String(operand))
        isCalculatorCleared = false
        
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
        "=": Operation.Equals,
        "C": Operation.ClearAll
    ]
    
    
    
    
    
    var isPartialResult: Bool {
        return pending != nil ? true : false
    }
    
    private  enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case ClearAll
    }
    
    var isAddingToHistoryDescription = true
    
    var isCalculatorCleared = false
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]
        {
            switch operation {
            case .Constant(let value):
                
                accumulator = value
                
          
                
            case .UnaryOperation (let function):
                if isPartialResult
                {
                    
                    let indexOfThreePoints = sequenceHistoryArray.indexOf("...")
                    sequenceHistoryArray[indexOfThreePoints!] = symbol
                    isAddingToHistoryDescription = false
                }
                
                if isAddingToHistoryDescription {
                sequenceHistoryArray.insert("(", atIndex: 0)
                sequenceHistoryArray.insert(symbol, atIndex: 0)
                let lastElement = sequenceHistoryArray.last!
                let indexOfLastElement = sequenceHistoryArray.indexOf(lastElement)
                sequenceHistoryArray.insert(")", atIndex: indexOfLastElement!)
                }
                
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstoperand: accumulator)
                if sequenceHistoryArray.last! == "="
                {
                    sequenceHistoryArray.removeLast()
                }
                sequenceHistoryArray.append(symbol)
                
                
                
            case .Equals:
                executePendingBinaryOperation()
                sequenceHistoryArray.append(symbol)
            case.ClearAll:
                accumulator = 0.0
          
                isCalculatorCleared = true
                
                
                
            }
            
            
        }
        
    }
    
    
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            if isAddingToHistoryDescription
            {
               // description += String(accumulator)
            }
            secondAccumulator = accumulator
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