import Combine
import Foundation

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

struct ProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1s delay simülasyonu
        return Self.mockProducts
    }

    static let mockProducts: [Product] = [
        Product(name: "iPhone 15", description: "Latest iPhone with advanced features", price: 999.99),
        Product(name: "MacBook Pro", description: "Powerful laptop for professionals", price: 1999.99),
        Product(name: "AirPods Pro", description: "Wireless noise-canceling earbuds", price: 249.99),
        Product(name: "iPad Air", description: "Lightweight and powerful tablet", price: 599.99),
        Product(name: "Apple Watch", description: "Smart watch with health features", price: 399.99),
    ]
}

struct MockProductService: ProductServiceProtocol {
    var fetchProductsResult: Result<[Product], Error> = .success([])

    func fetchProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 100_000_000)
        return try fetchProductsResult.get()
    }
}
