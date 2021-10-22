//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var clearElements: UIButton!
    @IBOutlet weak var deleteLastNumber: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var elements: [String] {
        if textLabel.text == nil {textLabel.text = " "}
        return (textLabel.text!.split(separator: " ").map { "\($0)" })
    }
    
    var expressionHaveResult: Bool {
        return textLabel.text?.firstIndex(of: "=") != nil
    }
    
    lazy var calculation = Calculation(delegate: self)
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.2
    }
    
    @IBAction func clearNumbers(_ sender: Any) {
        textLabel.text = nil
    }
    
    @IBAction func deleteLastSymbol(_ sender: Any) {
        let symbol = textLabel.text!
        calculation.deleteThisSymbol(with: elements, and: symbol)
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        let symbol = textLabel.text
        if expressionHaveResult {
            textLabel.text = " "
        }
        self.calculation.handlePointAndNumber(with: elements, and: symbol ?? "", also: numberText )
    }
         
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        let symbol = sender.title(for: .normal)
        calculation.handleLastOperand(with: elements, and: symbol!)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        if (textLabel.text!.contains("=")) || (elements.count < 3) {
            return
        }
        
        calculation.calculate(with: elements, errorMessage: { (title: String, description: String) in
            self.presentPopUp(withTitle: title, andDescription: description)
        })
    }
    
}

// MARK: - CalculationDelegate

extension CalculatorViewController: CalculationDelegate {

    func append(result: String) {
        textLabel.text!.append(result)
    }
    
    func show(newResult: String) {
        textLabel.text = newResult
    }
    
    func deleteLastSymbol() {
        textLabel.text!.removeLast()
    }
    
    func deleteSymbol() {
        textLabel.text!.removeLast(3)
    }
}

// MARK: - Convenience Methods

 extension CalculatorViewController {
    
    func presentPopUp(withTitle title: String, andDescription description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

