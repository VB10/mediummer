import Foundation

struct BasketItem: Equatable, Identifiable {
    var id: UUID { product.id }
    let product: Product
    var quantity: Int
}

struct Basket: Equatable {
    var items: [BasketItem] = []
    
    var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    mutating func addProduct(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(BasketItem(product: product, quantity: 1))
        }
    }
    
    mutating func removeProduct(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else {
            return
        }
        
        items[index].quantity -= 1
        
        if items[index].quantity <= 0 {
            items.remove(at: index)
        }
    }
} 