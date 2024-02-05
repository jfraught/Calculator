//
//  ViewController.swift
//  Calculator
//
//  Created by Jordan Fraughton on 1/22/24.
//

import UIKit

class ViewController: UIViewController {
    var newNumberString = "0"
    var newNumber: Double?
    var currentTotal: Double = 0
    var operatorToBeUsed: OperationType?

    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var clearButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func updateNewNumber(with numberPressed: String) {
        if numberPressed == "." && newNumberString.description.contains(".") { return }
        if newNumberString == "0" { newNumberString = "" }
        clearButton.setTitle("C", for: .normal)
        newNumberString += numberPressed
        newNumber = Double(newNumberString)
        valueLabel.text = newNumberString
    }

    func updateTotal(with newNumber: Double, and operationTypeRawValue: Int) {
        let operationType = OperationType(rawValue: operationTypeRawValue)
        if currentTotal == 0 { currentTotal = newNumber}

        switch operationType {
        case .clear:
            newNumberString = "0"
            self.newNumber = 0
            if clearButton.title(for: .normal) == "C"  {
                clearButton.setTitle("AC", for: .normal)
                valueLabel.text = newNumberString
                return
            } else {
                currentTotal = 0
                operatorToBeUsed = nil
            }
        case .plusMinus:
            currentTotal = currentTotal == 0 ? currentTotal : -currentTotal
        case .percent:
            currentTotal /= 100
        case .divide, .multiply, .subtract, .add:
            if operatorToBeUsed != nil {
                currentTotal = runEquation(operatorToBeUsed: operatorToBeUsed, currentTotal: currentTotal, newNumber: newNumber)
                newNumberString = "0"
            }
            operatorToBeUsed = operationType
        case .equals:
            currentTotal = runEquation(operatorToBeUsed: operatorToBeUsed, currentTotal: currentTotal, newNumber: newNumber)
            operatorToBeUsed = nil
        case .none:
            print("Unknown operation type")
        }

        newNumberString = "0"
        valueLabel.text = floor(currentTotal) == currentTotal ? String(format: "%.0f", currentTotal) : String(currentTotal)
    }

    func runEquation(operatorToBeUsed: OperationType?, currentTotal: Double, newNumber: Double) -> Double {
        var total = currentTotal
        if let operatorToBeUsed {
            switch operatorToBeUsed {
            case .divide:
                total /= newNumber
            case .multiply:
                total *= newNumber
            case .subtract:
                total -= newNumber
            case .add:
                total += newNumber
            default:
                print("Not a valid operator")
            }
        }
        return total
    }

    @IBAction func numberButtonPressed(_ sender: UIButton) {
        guard let numberPressed = sender.configuration?.title else { return }
        updateNewNumber(with: numberPressed)
    }

    @IBAction func operationButtonTapped(_ sender: UIButton) {
        if let newNumber {
            updateTotal(with: newNumber, and: sender.tag)
        }
    }
}

enum OperationType: Int {
    case clear, plusMinus, percent, divide, multiply, subtract, add, equals
}

