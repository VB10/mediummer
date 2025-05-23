import Foundation
import ComposableArchitecture

struct TCAProductDetailFeature: Reducer {
    // MARK: - State
    
    struct State: Equatable {
        let product: Product
        var quantity: Int = 1
        var addedToBasket: Bool = false
        
        init(product: Product) {
            self.product = product
        }
    }
    
    // MARK: - Actions
    
    @CasePathable
    enum Action: Equatable {
        case incrementQuantity
        case decrementQuantity
        case addToBasket
        case setQuantity(Int)
    }
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementQuantity:
                state.quantity += 1
                return .none
                
            case .decrementQuantity:
                guard state.quantity > 1 else {
                    return .none
                }
                state.quantity -= 1
                return .none
                
            case .addToBasket:
                state.addedToBasket = true
                return .none
                
            case .setQuantity(let quantity):
                let safeQuantity = max(1, quantity)
                state.quantity = safeQuantity
                return .none
            }
        }
    }
} 