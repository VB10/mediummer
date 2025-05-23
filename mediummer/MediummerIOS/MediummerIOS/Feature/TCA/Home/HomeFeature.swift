import ComposableArchitecture
import Foundation

struct TCAHomeFeature: Reducer {
    // MARK: - State

    struct State: Equatable {
        var products: [Product] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var basket: Basket = Basket()
        var selectedProduct: Product?
        @PresentationState var productDetail: TCAProductDetailFeature.State?
        
        init(products: [Product] = [], isLoading: Bool = false, errorMessage: String? = nil) {
            self.products = products
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }
    
    // MARK: - Actions

    @CasePathable
    enum Action: Equatable {
        case onAppear
        case loadProducts
        case productsResponse(TaskResult<[Product]>)
        case productSelected(Product)
        case productDetail(PresentationAction<TCAProductDetailFeature.Action>)
        case addToBasket(Product, quantity: Int)
        case dismissProductDetail
    }
    
    // MARK: - Dependencies

    @Dependency(\.productService) var productService
    
    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadProducts)
                
            case .loadProducts:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    do {
                        let products = try await productService.fetchProducts()
                        await send(.productsResponse(.success(products)))
                    } catch {
                        await send(.productsResponse(.failure(error)))
                    }
                }

            case .productsResponse(.success(let products)):
                state.isLoading = false
                state.products = products
                return .none
                
            case .productsResponse(.failure(let error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .productSelected(let product):
                state.selectedProduct = product
                state.productDetail = TCAProductDetailFeature.State(product: product)
                return .none
                
            case .productDetail(.presented(.addToBasket)):
                guard let detailState = state.productDetail else { return .none }
                return .send(.addToBasket(detailState.product, quantity: detailState.quantity))
                
            case .addToBasket(let product, let quantity):
                // Add the product to basket multiple times based on quantity
                for _ in 0..<quantity {
                    state.basket.addProduct(product)
                }
                return .send(.dismissProductDetail)
                
            case .dismissProductDetail:
                state.productDetail = nil
                return .none
                
            case .productDetail:
                return .none
            }
        }
        .ifLet(\.$productDetail, action: /Action.productDetail) {
            TCAProductDetailFeature()
        }
    }
}

// MARK: - Dependencies

extension DependencyValues {
    private enum ProductServiceKey: DependencyKey {
        static let liveValue: ProductServiceProtocol = ProductService()
        static let testValue: ProductServiceProtocol = MockProductService()
    }

    var productService: ProductServiceProtocol {
        get { self[ProductServiceKey.self] }
        set { self[ProductServiceKey.self] = newValue }
    }
}
