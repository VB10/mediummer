import SwiftUI
import ComposableArchitecture

struct TCAHomeView: View {
    let store: StoreOf<TCAHomeFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ZStack {
                    // Product list
                    List {
                        ForEach(viewStore.products) { product in
                            TCAProductRow(product: product)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewStore.send(.productSelected(product))
                                }
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Products")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if viewStore.basket.totalItemCount > 0 {
                                BasketBadgeView(count: viewStore.basket.totalItemCount)
                            }
                        }
                    }
                    
                    // Loading indicator
                    if viewStore.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle())
                            .background(Color.white.opacity(0.3))
                    }
                    
                    // Error message
                    if let errorMessage = viewStore.errorMessage {
                        VStack {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                            
                            Button("Retry") {
                                viewStore.send(.loadProducts)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
            .sheet(
                store: self.store.scope(
                    state: \.$productDetail,
                    action: \.productDetail
                )
            ) { store in
                NavigationStack {
                    TCAProductDetailView(store: store)
                }
            }
        }
    }
}

// MARK: - Product Row Component
struct TCAProductRow: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.name)
                .font(.headline)
            
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("$\(String(format: "%.2f", product.price))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Basket Badge View
struct BasketBadgeView: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart.fill")
                .font(.system(size: 24))
                .foregroundColor(.blue)
            
            Text("\(count)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.red)
                .clipShape(Circle())
                .offset(x: 10, y: -10)
        }
    }
}

#Preview {
    TCAHomeView(
        store: Store(
            initialState: TCAHomeFeature.State()
        ) {
            TCAHomeFeature()
        }
    )
} 
