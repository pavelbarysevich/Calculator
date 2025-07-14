import SwiftUI

// Точка входа в приложение калькулятора
@main
struct CalculatorApp: App {
    // ViewModel создаётся один раз на всё приложение
    let model = CalculatorViewModel()
    var body: some Scene {
        WindowGroup {
            // MainView — главный экран калькулятора
            // .environment(model) — передаём ViewModel через environment для всех дочерних View
            MainView()
                .environment(model)
        }
    }
}
