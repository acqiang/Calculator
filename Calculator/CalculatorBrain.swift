//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by qiang on 16/1/11.
//  Copyright © 2016年 qiang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private  enum Op{
        case Operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
    
    var description : String{
        get{
            switch self{
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    }
    
  private  var opStack = [Op]()
    
//    var knownOps = Dictionary<String,Op>()
  private  var knonwnOps = [String:Op]()
    
    init(){
        knonwnOps["×"] = Op.BinaryOperation("×",*)
        knonwnOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knonwnOps["+"] = Op.BinaryOperation("+",+)
        knonwnOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knonwnOps["√"] = Op.UnaryOperation ("√",sqrt)
    }
    
    
    typealias PropertyList = AnyObject
    var program:PropertyList{ // guaranteed to be a PropertyList
        get{
            return opStack.map { $0.description }
            /*
            var returnValue = Array<String>()
            for op  in opStack{
                returnValue.append(op.description)
            }
            return returnValue
            */
        }
        set{
            if let opSymbols = newValue as?Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knonwnOps[opSymbol]{
                        newOpStack.append(op)
                    }else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
  private  func evaluate(ops: [Op]) -> (result:Double?,remainingOps:[Op]){
    if !ops.isEmpty{
        var remainingOps = ops
        let op = remainingOps.removeLast()
        switch op{
        case .Operand(let operand):
            return (operand,remainingOps)
        case .UnaryOperation(_, let operation):
            let operandEvalution = evaluate(remainingOps)
            if let operand = operandEvalution.result{
                return (operation(operand),operandEvalution.remainingOps)
            }
        case .BinaryOperation(_, let operation):
            let op1Evalution = evaluate(remainingOps)
            if let operand1 = op1Evalution.result{
                let op2Evaluation = evaluate(op1Evalution.remainingOps)
                if let operand2 = op2Evaluation.result{
                    return (operation(operand1,operand2),op2Evaluation.remainingOps)
                }
            }
        }
    }
    return (nil,ops)
    }
    
    func  evaluate() -> Double? {
        let (result,remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperandA(operand:Double)->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String)->Double?{
       if let operation = knonwnOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
  

    
    
}
