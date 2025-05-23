//
//  TCAHomeFeatureTests.swift
//  MediummerIOSTests
//
//  Created by vb10 on 21.05.2025.
//

import XCTest
import ComposableArchitecture
@testable import MediummerIOS

@MainActor
final class TCAHomeFeatureTests: XCTestCase {
    
    func testFetchProductsSuccess() async {
        // Setup
        let mockProducts = [
            Product(id: UUID(0), name: "Test Product 1", description: "Description 1", price: 10.99),
            Product(id: UUID(1), name: "Test Product 2", description: "Description 2", price: 20.99)
        ]
        
        let testStore = TestStore(
            initialState: TCAHomeFeature.State()
        ) {
            TCAHomeFeature()
        } withDependencies: {
            $0.productService = MockProductService(fetchProductsResult: .success(mockProducts))
        }
        
        // Test
        await testStore.send(.onAppear) {
            // This action immediately triggers loadProducts
            $0.isLoading = true
        }
        
        await testStore.receive(.loadProducts)
        
        await testStore.receive(.productsResponse(.success(mockProducts))) {
            $0.isLoading = false
            $0.products = mockProducts
        }
    }
    
    func testFetchProductsFailure() async {
        // Setup
        let error = NSError(domain: "TestError", code: 1234, userInfo: [NSLocalizedDescriptionKey: "Test error message"])
        
        let testStore = TestStore(
            initialState: TCAHomeFeature.State()
        ) {
            TCAHomeFeature()
        } withDependencies: {
            $0.productService = MockProductService(fetchProductsResult: .failure(error))
        }
        
        // Test
        await testStore.send(.onAppear) {
            // This action immediately triggers loadProducts
            $0.isLoading = true
        }
        
        await testStore.receive(.loadProducts)
        
        await testStore.receive(.productsResponse(.failure(error))) {
            $0.isLoading = false
            $0.errorMessage = error.localizedDescription
        }
    }
    
    func testProductSelection() async {
        // Setup
        let product = Product(id: UUID(0), name: "Test Product", description: "Description", price: 10.99)
        
        let testStore = TestStore(
            initialState: TCAHomeFeature.State(products: [product])
        ) {
            TCAHomeFeature()
        }
        
        // Test
        await testStore.send(.productSelected(product)) {
            $0.selectedProduct = product
            $0.productDetail = TCAProductDetailFeature.State(product: product)
        }
    }
    
    func testAddToBasket() async {
        // Setup
        let product = Product(id: UUID(0), name: "Test Product", description: "Description", price: 10.99)
        let quantity = 3
        
        let testStore = TestStore(
            initialState: TCAHomeFeature.State()
        ) {
            TCAHomeFeature()
        }
        
        // Test
        await testStore.send(.addToBasket(product, quantity: quantity)) {
            var basket = Basket()
            for _ in 0..<quantity {
                basket.addProduct(product)
            }
            $0.basket = basket
        }
        
        await testStore.receive(.dismissProductDetail)
    }
    
    func testDismissProductDetail() async {
        // Setup
        let product = Product(id: UUID(0), name: "Test Product", description: "Description", price: 10.99)
        
        let initialState = TCAHomeFeature.State()
        var state = initialState
        state.selectedProduct = product
        state.productDetail = TCAProductDetailFeature.State(product: product)
        
        let testStore = TestStore(
            initialState: state
        ) {
            TCAHomeFeature()
        }
        
        // Test
        await testStore.send(.dismissProductDetail) {
            $0.productDetail = nil
        }
    }
}

// Helper extension for creating deterministic UUIDs for testing
extension UUID {
    init(_ value: Int) {
        var uuid = UUID().uuid
        uuid.0 = UInt8(value & 0xFF)
        self = UUID(uuid: uuid)
    }
} 
