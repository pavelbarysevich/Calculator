import SwiftUI

struct MainView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        
        //MARK: background
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack (spacing: 12) {
                Spacer()
                
                //Mark: current view buttons
                HStack() {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(viewModel.value)
                            .foregroundColor(.white)
                            .font(.system(size: 100, weight: .light))
                            .padding(.horizontal, 28)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                ForEach(viewModel.arrayButtons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button {
                                viewModel.tapBattons(item: item)
                            } label: {
                                Text(item.rawValue)
                                    .font(.system(size: 35))
                                    .frame(
                                        width: viewModel.buttonWidth(item: item),
                                        height: viewModel.buttonHeight()
                                    )
                                    .background(item.colorButtons)
                                    .foregroundColor(.white)
                                    .cornerRadius(.infinity)
                            }

                        }
                    }
                }
            }
            .padding(.bottom)
            
        }
    }
}

extension MainView {
    class ViewModel {
        var value: String = "0"
        var number: Double = 0
        var currentOperation: Buttons?
        
        let arrayButtons: [[Buttons]] = [
            [.clean, .divide, .multiply, .minus],
            [.seven, .eight, .nine, .plus],
            [.four, .five, .six, .equal],
            [.one, .two, .three, .equal],
            [.zero]
        ]
        
        func tapBattons(item: Buttons) {
            switch item {
            case .clean:
                value = "0"
                number = 0
                currentOperation = nil
            case .plus, .minus, .multiply, .divide:
                if let newValue = Double(value) {
                    number = newValue
                    value = "0"
                    currentOperation = item
                }
            case .equal:
                if let newValue = Double(value), let operation = currentOperation {
                    performOperation(operation, with: newValue)
                    currentOperation = nil
                }
            default:
                if value == "0" {
                    value = item.rawValue
                } else {
                    value += item.rawValue
                }
            }
        }
        
        private func performOperation(_ operation: Buttons, with newValue: Double) {
            switch operation {
            case .plus:
                number += newValue
            case .minus:
                number -= newValue
            case .multiply:
                number *= newValue
            case .divide:
                if newValue != 0 {
                    number /= newValue
                } else {
                    // handle divide by zero if needed
                    number = 0
                }
            default:
                break
            }
            value = formatResult(number)
        }
        
        private func formatResult(_ number: Double) -> String {
            if number.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", number)
            } else {
                return String(number)
            }
        }
        
        func buttonWidth(item: Buttons) -> CGFloat {
            if item == .zero {
                return 170
            }
            return 80
        }
        
        func buttonHeight() -> CGFloat {
            80
        }
    }
    
    enum Buttons: String, Hashable {
        case zero = "0", one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9"
        case plus = "+"
        case minus = "-"
        case multiply = "×"
        case divide = "÷"
        case equal = "="
        case clean = "C"
        
        var colorButtons: Color {
            switch self {
            case .plus, .minus, .multiply, .divide, .equal:
                return .orange
            case .clean:
                return .gray
            default:
                return Color(.darkGray)
            }
        }
    }
}

#Preview {
    MainView()
}
