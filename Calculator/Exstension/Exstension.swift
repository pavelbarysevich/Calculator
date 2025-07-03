import SwiftUI

extension Buttons {
    func buttonsToOparetions() -> Operations {
        switch self {
        case  .plus:
            return .addition
        case  .minus:
            return .subtraction
        case  .multiply:
            return .multiplication
        case  .divide:
            return .distribution
        default:
              return  .none
        }
    }
}

