//
//  Calculation.swift
//  CountOnMe
//
//  Created by Mohammad Olwan on 03/10/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculationDelegate {
    func append(result: String)
    func show(newResult: String)
    func deleteSymbol()
    func deleteLastSymbol()
}

class Calculation {
    
    var delegate: CalculationDelegate
    
    private var elements: [String] = []
    
    init(delegate: CalculationDelegate) {
        self.delegate = delegate
    }
    
    var result: Double = 0
    
    func calculate(with elements: [String], errorMessage: (_ title: String, _ description: String) -> Void) {
        
        self.elements = elements
    
        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations while an operand still here
        let ops = ["×","÷","-","+"]
        for i in 0...ops.count - 1 {
            var index = operationsToReduce.firstIndex(of: ops[i])
            var  result : Double
            while index != nil {
                let b: Double = Double(operationsToReduce[index! - 1])!
                let c: Double = Double(operationsToReduce[index! + 1])!
                switch ops[i] {
                case "×":  result  = b * c
                case "÷": if c == 0 {
                    errorMessage("Zéro!", "C'est interdit de divider sur zéro !")
                    result = Double.infinity
                }
                else { result  = b / c
                }
                case "-":  result  = b - c
                case "+":  result  = b + c
                default: continue //fatalError("Unknown operator !")
                }
                
                operationsToReduce[index! - 1] = String(result.clean)
                operationsToReduce.remove(at: index! )
                operationsToReduce.remove(at: index! )
                index = operationsToReduce.firstIndex(of: ops[i])
            }
        }        
        self.delegate.append(result: " = \(operationsToReduce[0])")
    }
}

// MARK: - HandleLastNonDigitSymbol

extension Calculation {
    
    func handleLastOperand(with elements: [String],and symbol: String) {
 
        self.elements = elements
        if (self.elements.last == "+" || self.elements.last == "-" || self.elements.last == "×" || self.elements.last == "÷") && (!elements.contains("=")) {
            self.delegate.deleteSymbol()
        }
        else if (self.elements.contains("=")) {
            self.delegate.show(newResult: "\(elements.last!)" )
        }
        
        else if (symbol == "-" ) && ( self.elements.isEmpty){
            self.delegate.append(result: "\(symbol)")
            return
        }
        else if (symbol == "×" || symbol == "÷" || symbol == "+" ) && ( self.elements.isEmpty){
            return
        }
        self.delegate.append(result: " \(symbol) ")
    }
}

// MARK: - DeleteLastSymbol

extension Calculation {
    
    
    func deleteThisSymbol(with elements: [String],and symbol: String) {
        if symbol != ""
        {
            if (elements.last == "+" || elements.last == "-" || elements.last == "/" || elements.last == "*" || elements.last == "="){
                self.delegate.deleteSymbol()
            }
            else {
                self.delegate.deleteLastSymbol()
            }
        }
        else {
            return
        }
    }
}

// MARK: - HandlePointAndNumber

extension Calculation {
    
    func handlePointAndNumber(with elements: [String],and symbol: String, also symbolTapped: String) {
        
        if ( symbolTapped == ".") && (symbol == " " || symbol == "") || (symbolTapped == "." && Double(elements.last!) == nil) {
            self.delegate.append(result: "0.")
        }
        
        else if (symbolTapped == "." && !elements.last!.contains(".") && Double(elements.last!) != nil) {
            self.delegate.append(result: symbolTapped)
        }
        
        else  if (symbolTapped == "." && elements.last!.contains(".") ) {
            return
        }
        
        else if ( symbolTapped != "0" && elements.last?.count == 1 && elements.last! == "0" ){
            self.delegate.deleteLastSymbol()
            self.delegate.append(result: symbolTapped)
        }
        else if ( symbolTapped == "0" && elements.last?.count == 1 && elements.last! == "0" ){
            return
        }
        
        else {
            self.delegate.append(result: symbolTapped)
        }
    }
}
