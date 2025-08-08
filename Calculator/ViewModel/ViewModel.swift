import SwiftUI
import Observation

// ViewModel калькулятора: бизнес-логика, состояние, история
@Observable
final class CalculatorViewModel {
    // Текущее выражение, отображаемое на экране (например, "2+2")
    var expression: String = ""
    // Результат вычисления (nil, если не нажато "=")
    var result: String? = nil
    // История вычислений (массив строк вида "2+2 = 4")
    var history: [String] = []
    // Кнопки калькулятора, разбитые по строкам для отображения
    let buttons: [[CalculatorButton]] = [
        [.ac, .sign, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equal]
    ]
    
    // Основная функция обработки нажатия кнопки калькулятора
    func handleTap(_ button: CalculatorButton) {
        // Если на экране ошибка — разрешаем только очистку
        if let res = result, res == "На 0 делить нельзя" || res == "Ошибка" {
            if button == .ac { clear() }
            return
        }
        switch button {
        case .ac:
            clear() // Полная очистка
        case .backspace:
            removeLastSymbol() // Удалить последний символ
        case .equal:
            calculate() // Вычислить результат
        default:
            append(button) // Добавить символ к выражению
        }
    }
    
    // Добавляет символ к выражению или начинает новое выражение после результата
    private func append(_ button: CalculatorButton) {
        // Если только что был показан результат — начинаем новое выражение или продолжаем с результатом
        if let res = result {
            switch button {
            case .plus, .minus, .multiply, .divide:
                expression = res + button.rawValue
                result = nil
                return
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .dot:
                expression = ""
                result = nil
            default:
                return
            }
        }
        // Логика предотвращения некорректного ввода (несколько нулей, точек и т.д.)
        let lastNumber = lastNumberInExpression(expression)
        switch button {
        case .zero:
            if expression.isEmpty { expression = "0"; return }
            if lastNumber == "0" { return }
            if lastNumber.hasPrefix("0") && !lastNumber.contains(".") && lastNumber.count == 1 { return }
            expression += "0"
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if lastNumber == "0" && !lastNumber.contains(".") {
                expression = String(expression.dropLast()) + button.rawValue
            } else {
                expression += button.rawValue
            }
        case .dot:
            if expression.isEmpty || isLastCharOperation(expression) {
                expression += "0."
                return
            }
            if lastNumber.contains(".") { return }
            expression += "."
        case .plus, .minus, .multiply, .divide:
            if expression.isEmpty { return }
            if isLastCharOperation(expression) { return }
            expression += button.rawValue
        case .sign:
            // Смена знака у последнего числа
            guard !expression.isEmpty else { return }
            var chars = Array(expression)
            let end = chars.count - 1
            var start = end
            while start >= 0 && (chars[start].isNumber || chars[start] == ".") { start -= 1 }
            start += 1
            if start > 0 && chars[start - 1] == "-" && (start == 1 || ["+", "-", "×", "÷"].contains(String(chars[start - 2]))) {
                chars.remove(at: start - 1)
            } else {
                chars.insert("-", at: start)
            }
            expression = String(chars)
        default:
            break
        }
    }
    
    // Вычисляет результат выражения и сохраняет его в result и history
    private func calculate() {
        guard !expression.isEmpty else { return }
        // Проверка на некорректное выражение (заканчивается на операцию)
        if let last = expression.last, ["+", "-", "×", "÷", "%"].contains(String(last)) {
            result = "Ошибка"
            return
        }
        // Проверка на деление на 0
        if expression.hasSuffix("÷0") || expression.hasSuffix("÷0.") {
            result = "На 0 делить нельзя"
            return
        }
        // Преобразование выражения для NSExpression
        let exp = expression.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/")
        let expr = NSExpression(format: exp)
        if let value = expr.expressionValue(with: nil, context: nil) as? NSNumber {
            let doubleValue = value.doubleValue
            if doubleValue.isInfinite || doubleValue.isNaN {
                result = "На 0 делить нельзя"
            } else {
                result = formatResult(doubleValue)
                saveCurrentToHistory()
            }
        } else {
            result = "Ошибка"
        }
    }
    
    // Сохраняет текущее выражение и результат в историю
    func saveCurrentToHistory() {
        guard let res = result, !expression.isEmpty else { return }
        let entry = "\(expression) = \(res)"
        history.append(entry)
    }
    
    // Удаляет последний символ из выражения или полностью очищает, если символ один
    func removeLastSymbol() {
        if !expression.isEmpty {
            expression.removeLast()
            if expression.isEmpty {
                clear()
            }
        } else {
            clear()
        }
    }
    
    // Полная очистка выражения и результата
    private func clear() {
        expression = ""
        result = nil
    }
    
    // Форматирует результат для отображения (убирает лишние нули, не использует экспоненциальную запись)
    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } else {
            return String(format: "%.6f", result)
                .replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
                .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
        }
    }
    
    // Вспомогательная функция: получить последнее число из выражения
    private func lastNumberInExpression(_ expression: String) -> String {
        var number = ""
        for char in expression.reversed() {
            if char.isNumber || char == "." { number = String(char) + number } else { break }
        }
        return number
    }
    // Вспомогательная функция: проверить, является ли последний символ операцией
    private func isLastCharOperation(_ expression: String) -> Bool {
        guard let last = expression.last else { return false }
        return ["+", "-", "×", "÷"].contains(String(last))
    }
    // Размеры кнопок для адаптивного интерфейса
    // Использует переданную ширину экрана вместо UIScreen.main.bounds.width для гибкости
    func buttonWidth(_ button: CalculatorButton, screenWidth: CGFloat) -> CGFloat {
        let spacing: CGFloat = 12
        let rowSpacing: CGFloat = 5 * spacing
        let zeroSpacing: CGFloat = 4 * spacing
        let row: CGFloat = 4
        let screen: CGFloat = screenWidth // Переменная screen типа CGFloat получает значение ширины экрана, переданное через параметр screenWidth.
        if button == .zero {
            return (screen - zeroSpacing) / row * 2
        }
        return (screen - rowSpacing) / row
    }
    // Использует переданную ширину экрана вместо UIScreen.main.bounds.width для гибкости
    func buttonHeight(screenWidth: CGFloat) -> CGFloat {
        let spacing: CGFloat = 12
        let rowSpacing: CGFloat = 5 * spacing
        let row: CGFloat = 4
        let screen: CGFloat = screenWidth // Переменная screen типа CGFloat получает значение ширины экрана, переданное через параметр screenWidth.
        return (screen - rowSpacing) / row
    }
}
