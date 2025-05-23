import SwiftUI
import ComposableArchitecture

struct TCAProductDetailView: View {
    let store: StoreOf<TCAProductDetailFeature>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Product Image (Placeholder)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(16/9, contentMode: .fit)
                        
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)
                    
                    // Product Details
                    Text(viewStore.product.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("$\(String(format: "%.2f", viewStore.product.price))")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.bottom, 4)
                    
                    Text(viewStore.product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 16)
                    
                    // Quantity Selector
                    HStack {
                        Text("Quantity:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            viewStore.send(.decrementQuantity)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                        }
                        .disabled(viewStore.quantity <= 1)
                        
                        Text("\(viewStore.quantity)")
                            .font(.title3)
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            viewStore.send(.incrementQuantity)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    // Add to Basket Button
                    Button(action: {
                        viewStore.send(.addToBasket)
                        
                        // Give some time for animation or feedback
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack {
                            Text(viewStore.addedToBasket ? "Added to Basket" : "Add to Basket")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.2f", viewStore.product.price * Double(viewStore.quantity)))")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewStore.addedToBasket ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewStore.addedToBasket)
                }
                .padding()
            }
            .navigationTitle("Product Details")
        }
    }
}

#Preview {
    NavigationView {
        TCAProductDetailView(
            store: Store(
                initialState: TCAProductDetailFeature.State(
                    product: Product(
                        name: "iPhone 15",
                        description: "Latest iPhone with advanced features and incredible performance. Experience the best of Apple's innovations in a sleek design.",
                        price: 999.99
                    )
                )
            ) {
                TCAProductDetailFeature()
            }
        )
    }
} 