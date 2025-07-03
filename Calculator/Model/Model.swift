import SwiftUI

enum Operations {
    case addition
    case subtraction
    case multiplication
    case distribution
    case none
}

enum Buttons: String {
    case clean = "AC"
    case changeOfSign = "+/-"
    case percent = "%"
    case divide = "/"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case multiply = "X"
    case four = "4"
    case five = "5"
    case six = "6"
    case minus = "-"
    case one = "1"
    case two = "2"
    case three = "3"
    case plus = "+"
    case zero = "0"
    case dot = "."
    case equal = "="
    
    var colorButtons: Color {
        switch self {
        case .clean, .changeOfSign, .percent:
            return .slightGrayC
        case .divide, .multiply, .minus, .plus:
            return .orsngeC
        default:
            return .grayC
        }
    }
    
}
