import SwiftUI

struct MainView: View {
    // ViewModel калькулятора, получаем из environment
    @Environment(CalculatorViewModel.self) private var model
    // Состояние для отображения sheet с историей
    @State private var showHistory = false
    
    var body: some View {
        // Текст, который отображается на экране (результат или выражение)
        let displayText = model.result ?? (model.expression.isEmpty ? "0" : model.expression)
        ZStack(alignment: .topTrailing) {
            // Фон приложения — чёрный
            Color.black.ignoresSafeArea()
            VStack(spacing: 12) {
                Spacer()
                // Блок отображения результата или выражения
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        // ZStack для анимации смены текста
                        ZStack {
                            // Если ошибка — показываем ошибку красным
                            if let result = model.result, result == "Ошибка" || result == "На 0 делить нельзя" {
                                Text(String(result.prefix(30)))
                                    .id(result)
                                    .foregroundColor(.red)
                                    .font(.system(size: 90, weight: .light))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                                    .padding(.horizontal, 28)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .transition(.opacity)
                            } else {
                                // Иначе — выражение или результат белым
                                Text(String(displayText.prefix(30)))
                                    .id(displayText)
                                    .foregroundColor(.white)
                                    .font(.system(size: 90, weight: .light))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                                    .padding(.horizontal, 28)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .transition(.opacity)
                            }
                        }
                        // Анимация смены текста
                        .animation(.linear(duration: 0.02), value: model.result ?? displayText)
                    }
                }
                // Первая строка кнопок: динамически AC или ⌫
                HStack(spacing: 12) {
                    // Если результат есть или символов <= 1 — AC, иначе ⌫
                    let firstButton: CalculatorButton = (model.result != nil || model.expression.count <= 1) ? .ac : .backspace
                    ForEach([firstButton] + Array(model.buttons[0].dropFirst()), id: \.self) { button in
                        Button {
                            model.handleTap(button)
                        } label: {
                            Text(button.rawValue)
                                .font(.system(size: 35))
                                .frame(
                                    width: model.buttonWidth(button),
                                    height: model.buttonHeight()
                                )
                                .background(button.color)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                    }
                }
                // Остальные строки кнопок калькулятора
                ForEach(Array(model.buttons.dropFirst()).enumerated(), id: \.offset) { _, row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button {
                                model.handleTap(button)
                            } label: {
                                Text(button.rawValue)
                                    .font(.system(size: 35))
                                    .frame(
                                        width: model.buttonWidth(button),
                                        height: model.buttonHeight()
                                    )
                                    .background(button.color)
                                    .foregroundColor(.white)
                                    .cornerRadius(.infinity)
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
            // Кнопка открытия истории (книга) в правом верхнем углу
            HStack {
                Button {
                    showHistory = true
                } label: {
                    Image(systemName: "book")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.white)
                        .padding(16)
                }
                Spacer()
            }
        }
        // Окно истории вычислений
        .sheet(isPresented: $showHistory) {
            NavigationView {
                // Список истории, каждая запись — отдельная выделенная ячейка
                List(model.history.reversed(), id: \.self) { entry in
                    HStack {
                        Text(entry)
                            .font(.system(size: 22, weight: .regular))
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(12)
                    .padding(.vertical, 2)
                    .listRowBackground(Color.black)
                }
                .navigationTitle("История")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Закрыть") { showHistory = false }
                            .foregroundColor(.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
            }
            .background(Color.black)
            .presentationDetents([.fraction(0.6), .fraction(1.0)])
        }
    }
}

#Preview {
    MainView().environment(CalculatorViewModel())
}
