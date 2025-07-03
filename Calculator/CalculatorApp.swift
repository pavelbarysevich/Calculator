import SwiftUI

@main
struct CalculatorApp: App {
    
    let viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(viewModel)
        }
    }
}
