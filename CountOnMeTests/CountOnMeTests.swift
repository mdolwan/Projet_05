//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe



class CountOnMeTests: XCTestCase {
    
    lazy var calculation = Calculation(delegate: self)
    
    var elements: [String] {
        (labelText.split(separator: " ").map { "\($0)" })
    }
    
    var labelText: String = ""
    var symbol : String = ""
    func test_result_should_be_zero_when_there_is_no_operation() {
        XCTAssertEqual(calculation.result, 0)
    }

    func test_while_user_tap_on_equal_button_then_he_should_see_the_result() {
        // Arrange
        labelText = "5 + 5"
        // Act + Assert
        whenUserHasPressedEqual(thenResultShouldBe: "5 + 5 = 10")
        
        // Arrange
        labelText = "5 - 3"
        // Act + Assert
        whenUserHasPressedEqual(thenResultShouldBe: "5 - 3 = 2")
        
    }
    
    func test_operation_should_have_priorities() {
        let operationsToTest: [(labelText: String, result: String)] = [
            ( labelText: "5 × 2 + 5", result: "5 × 2 + 5 = 15"),
            ( labelText: "5 + 2 × 5", result: "5 + 2 × 5 = 15"),
        ]
        for operation in operationsToTest {
            labelText = operation.labelText
            whenUserHasPressedEqual(thenResultShouldBe: operation.result)
        }
    }
    func test_operation_on_zero_should_have_inf() {
        
        let operationsToTest: [(labelText: String, result: String)] = [
            ( labelText: "5 ÷ 0", result: "5 ÷ 0 = inf"),
            ( labelText: "0 ÷ 5", result: "0 ÷ 5 = 0"),
        ]
        for operation in operationsToTest {
            labelText = operation.labelText
            whenUserHasPressedEqual(thenResultShouldBe: operation.result)
        }
    }
    
    // handleLastOperand
    func test_if_there_operand_and_tapped_another_operand_then_must_showing_the_last_operand(){
        // Tuple: (symbol: String, labelText: String, result: String)
        let operationsToTest: [(symbol: String, labelText: String, result: String)] = [
            (symbol: "+", labelText: "5 - ", result: "5 + "),
            (symbol: "-", labelText: "5 + ", result: "5 - "),
            (symbol: "-", labelText: "", result: "-"),
            (symbol: "+", labelText: "3 + 6 = 9", result: "9 + "),
            (symbol: "×", labelText: "", result: ""),
            (symbol: "+", labelText: "", result: ""),
            (symbol: "÷", labelText: "", result: ""),
        ]
        
        for operation in operationsToTest {
            symbol = operation.symbol
            labelText = operation.labelText
            whenUserHaschangedOperand(thenResultShouldBe: operation.result)
        }
    }
    
    // handlePointAndNumber
    func test_if_point_has_tapped_then_handel_it() {
        
        let operationsToTest: [(symbol: String, labelText: String, result: String)] = [
            (symbol: ".", labelText: "", result: "0."),
            (symbol: ".", labelText: "0.5", result: "0.5"),
            (symbol: ".", labelText: "5", result: "5."),
            (symbol: "0", labelText: "0", result: "0"),
            (symbol: "5", labelText: "0", result: "5"),
        ]
        for operation in operationsToTest {
            symbol = operation.symbol
            labelText = operation.labelText
            whenUserHasPressedPoint(thenResultShouldBe: operation.result)
        }
    }
    // deleteThisSymbol
    func test_delete_last_operand_or_last_number(){
        
        let operationsToTest: [(labelText: String, result: String)] = [
            ( labelText: "45", result: "4"),
            ( labelText: "4 + ", result: "4"),
            ( labelText: "", result: ""),
        ]
        for operation in operationsToTest {
            labelText = operation.labelText
            whenUserHasPresseDeleteButton(thenResultShouldBe: operation.result)
        }
    }
}

// MARK: - Convenience Methods

extension CountOnMeTests {
    
    private func whenUserHasPresseDeleteButton(thenResultShouldBe result: String) {
        // Act : User press equal button
        self.calculation.deleteThisSymbol(with: elements, and: labelText)
        // Assert
        XCTAssertEqual(labelText, result)
    }
    
    private func whenUserHasPressedPoint(thenResultShouldBe result: String) {
        // Act : User press equal button
        self.calculation.handlePointAndNumber(with: elements, and: labelText, also: symbol)
        // Assert
        XCTAssertEqual(labelText, result)
    }
    
    private func whenUserHasPressedEqual(thenResultShouldBe result: String) {
        // Act : User press equal button
        self.calculation.calculate(with: elements) { (_, _) in }
        // Assert
        XCTAssertEqual(labelText, result)
    }
    private func whenUserHaschangedOperand(thenResultShouldBe result: String) {
        // Act : User press equal button
        self.calculation.handleLastOperand(with: elements, and: symbol)
        // Assert
        XCTAssertEqual(labelText, result)
    }
}

// MARK: - CalculationDelegate

extension CountOnMeTests: CalculationDelegate {
   
    func append(result: String) {
        labelText.append(result)
    }
    
    func show(newResult: String) {
        labelText = newResult
    }
    
    func deleteSymbol() {
        labelText.removeLast(3)
    }
    
    func deleteLastSymbol() {
        labelText.removeLast()
    }
}
 
