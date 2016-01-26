//
//  ViewController.swift
//  Calculator
//
//  Created by qiang on 16/1/7.
//  Copyright © 2016年 qiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print("digit = \(digit)")
        if userIsTheMiddleOfTypingANumber{

            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsTheMiddleOfTypingANumber = true
        }
       
    }
//    var operandStack = Array<Double>()
    @IBAction func operate(sender: UIButton) {
        
        if userIsTheMiddleOfTypingANumber{
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    }

    @IBAction func enter() {
        userIsTheMiddleOfTypingANumber = false
        
        if let result = brain.pushOperandA(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
  
    }
    var displayValue : Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsTheMiddleOfTypingANumber = false
        }
    }
}

