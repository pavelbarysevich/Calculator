import SwiftUI

@Observable
class ViewModel {
    
    var value: String = "0"
    var number: Double = 0.0
    var currentOperation: Operations = .none
   
    //Mark: Array Buttons
    let arrayButtons: [[Buttons]] = [
        [.clean, .changeOfSign, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equal]
    ]
    
    func tapBattons(item: Buttons) {
        switch item {
        case .plus, .minus, .multiply, .divide:
            currentOperation = item.buttonsToOparetions()
            number = Double(value) ?? 0
            value = "0"
        case .clean:
            value = "0"
        case .changeOfSign:
            if let currentValue = Double(value) {
                value = formatResult(-currentValue)
            }
        case .percent:
            if let currentValue = Double(value) {
                value = formatResult((currentValue / 100) * number)
            }
        case .dot:
            if !value.contains(".") {
                value += "."
            }
        case .equal:
            if let currentValue = Double(value) {
                value = formatResult(performButtons(currentValue))
            }
        default:
            if value == "0" {
                value = item.rawValue
            } else {
                value += item.rawValue
            }
                
        }
    }
    
    //MARK: Remove last zero Method
    func formatResult(_ result: Double) -> String {
        return String(format: "%g", result)
    }
    
    //MARK: calculator method
    func performButtons(_ currentValue: Double) -> Double {
        switch currentOperation {
        case .addition:
            return number + currentValue
        case .subtraction:
            return number - currentValue
        case .multiplication:
            return number * currentValue
        case .distribution:
            return number / currentValue
        default:
            return currentValue
        }
    }
    
    
    //MARK: Func Buttons size Width and Height
    func buttonWidth(item: Buttons) -> CGFloat {
        let spasing: CGFloat = 12
        let rowItemSpasing: CGFloat = 5 * spasing
        let rowItemSpasingZero: CGFloat = 4 * spasing
        let row: CGFloat = 4
        let sizeScreen: CGFloat = UIScreen.main.bounds.width
        
        if item == .zero {
            return (sizeScreen - rowItemSpasingZero) / row * 2
        }
        
        return (sizeScreen - rowItemSpasing) / row
    }
    
    func  buttonHeight() -> CGFloat {
        let spasing: CGFloat = 12
        let rowItemSpasing: CGFloat = 5 * spasing
        let row: CGFloat = 4
        let sizeScreen: CGFloat = UIScreen.main.bounds.width
        
        return (sizeScreen - rowItemSpasing) / row
    }
}
