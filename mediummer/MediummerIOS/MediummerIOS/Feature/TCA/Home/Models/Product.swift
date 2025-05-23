import Foundation

struct Product: Equatable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    
    init(id: UUID = UUID(), name: String, description: String, price: Double) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
    }
} 