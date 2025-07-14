import SwiftUI

// Перечисление всех возможных операций калькулятора
enum Operation {
    case addition      // Сложение
    case subtraction   // Вычитание
    case multiplication // Умножение
    case division      // Деление
    case none          // Нет операции
}

// Перечисление всех кнопок калькулятора
// rawValue — символ, который отображается на кнопке
// CaseIterable и Hashable нужны для ForEach и уникальности
enum CalculatorButton: String, CaseIterable, Hashable {
    case ac = "AC"         // Очистить всё
    case backspace = "⌫"   // Удалить один символ
    case sign = "+/-"      // Смена знака
    case percent = "%"    // Процент
    case divide = "÷"      // Деление
    case multiply = "×"    // Умножение
    case minus = "-"       // Вычитание
    case plus = "+"        // Сложение
    case equal = "="       // Равно
    case dot = "."         // Десятичная точка
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"

    // Цвет кнопки в зависимости от типа
    var color: Color {
        switch self {
        case .ac, .sign, .percent, .backspace:
            return .slightGrayC // Светло-серый для служебных
        case .divide, .multiply, .minus, .plus, .equal:
            return .orsngeC     // Оранжевый для операций
        default:
            return .grayC       // Серый для цифр
        }
    }
}
