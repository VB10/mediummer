# TCA (The Composable Architecture) ile iOS Uygulama Mimarisi

## Genel Bakış

Bu proje, iOS uygulamaları için modern ve test edilebilir bir mimari olan TCA (The Composable Architecture) kullanılarak geliştirilmiştir. TCA, Point-Free tarafından oluşturulan, durum yönetimi, yan etkileri ele alma ve test edilebilirliği ön planda tutan bir mimaridir.

## Mimari Bileşenleri

### 1. Model Katmanı
```swift
struct Product: Equatable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
}
```

### 2. Servis Katmanı
```swift
protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

struct ProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        // Ürünleri getiren ve mock veri döndüren fonksiyon
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1s delay simülasyonu
        return Self.mockProducts
    }
}
```

### 3. TCA Bileşenleri

#### State
```swift
struct State: Equatable {
    var products: [Product] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var basket: Basket = Basket()
    var selectedProduct: Product?
    @PresentationState var productDetail: TCAProductDetailFeature.State?
}
```

#### Action
```swift
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
```

#### Reducer
```swift
struct TCAHomeFeature: Reducer {
    // State & Action tanımları...
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Aksiyon ve durum yönetimi
        }
        .ifLet(\.$productDetail, action: /Action.productDetail) {
            TCAProductDetailFeature()
        }
    }
}
```

#### Bağımlılık Yönetimi
```swift
@Dependency(\.productService) var productService

extension DependencyValues {
    var productService: ProductServiceProtocol {
        get { self[ProductServiceKey.self] }
        set { self[ProductServiceKey.self] = newValue }
    }
}
```

## Action-Reducer-State Deseni Detaylı İnceleme

TCA'nın temelinde "Action-Reducer-State" deseni yer alır. Bu desen, uygulamanın tüm veri akışını yönetir ve fonksiyonel programlama prensiplerini temel alır.

### Veri Akış Döngüsü

1. **Kullanıcı Etkileşimi/Sistem Olayı** → Bir Action tetiklenir.
2. **Action** → Reducer'a iletilir.
3. **Reducer** → Mevcut State ve Action'ı alır, yeni State üretir.
4. **State Değişimi** → UI otomatik olarak güncellenir.
5. **Yan Etkiler** → Gerekirse, Effect'ler aracılığıyla yeni Action'lar tetiklenir.

### State (Durum)

State, uygulamanın belirli bir andaki tüm verilerini içeren değiştirilemez (immutable) bir yapıdır:

```swift
struct HomeState: Equatable {
    // Temel veriler
    var products: [Product] = []
    
    // UI durumları
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var selectedProductID: UUID?
    
    // Hata yönetimi
    var error: ProductError?
    
    // Alt ekran durumları
    @PresentationState var productDetail: ProductDetailFeature.State?
    
    // Filtreleme/Sıralama seçenekleri
    var sortOrder: SortOrder = .nameAscending
    var filterCategory: ProductCategory?
    
    // Hesaplanan özellikler
    var filteredProducts: [Product] {
        // Filtreleme mantığı
        return products.filter { /* filtre koşulları */ }
    }
}
```

State'in temel özellikleri:
- Değişmez (immutable) yapıdır, değişiklikler sadece Reducer içinde gerçekleştirilir.
- `Equatable` uyumludur, performans optimizasyonu için değişiklikleri tespit etmeye yardımcı olur.
- Tüm UI durumlarını kapsamalıdır (loading, error states, selection states, vb.).
- Genellikle `struct` olarak tanımlanır ve copy-on-write semantiğini kullanır.
- Alt ekranların durumları için `@PresentationState` kullanılır.

### Action (Aksiyon)

Action'lar, sistemde gerçekleşen olayları temsil eden enum değerleridir:

```swift
@CasePathable
enum HomeAction: Equatable {
    // Kullanıcı eylemleri
    case onAppear
    case productTapped(id: UUID)
    case refreshButtonTapped
    case sortOrderChanged(SortOrder)
    case filterApplied(ProductCategory?)
    
    // Asenkron yanıtlar
    case productsResponse(TaskResult<[Product]>)
    case productDetailsResponse(TaskResult<ProductDetail>)
    
    // Alt bileşen aksiyonları
    case productDetail(PresentationAction<ProductDetailAction>)
    
    // Zamanlayıcı/İç aksiyonlar
    case timerTick
}
```

Action'ların temel özellikleri:
- Her Action bir kullanıcı etkileşimini, sistem olayını veya asenkron yanıtı temsil eder.
- İlişkili verileri taşıyabilir (id, değerler, sonuçlar vb.).
- Genellikle `enum` olarak tanımlanır ve tüm olası durumları kapsar.
- Alt bileşenlerin Action'larını da kapsayabilir (composition).
- `@CasePathable` macro ile desteklenir, bu sayede key path'ler kullanılabilir.

### Reducer (İndirgeyici)

Reducer, bir State ve Action'ı alıp yeni bir State ve olası Effect'ler üreten saf bir fonksiyondur:

```swift
struct HomeFeature: Reducer {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // Uygulama açıldığında yapılacaklar
                state.isLoading = true
                return .send(.loadProducts)
                
            case .loadProducts:
                // Ürünleri yükleme
                return .run { send in
                    do {
                        let products = try await productService.fetchProducts()
                        await send(.productsResponse(.success(products)))
                    } catch {
                        await send(.productsResponse(.failure(error)))
                    }
                }
                
            case .productsResponse(.success(let products)):
                // Başarılı yanıt
                state.isLoading = false
                state.products = products
                state.error = nil
                return .none
                
            case .productsResponse(.failure(let error)):
                // Hata durumu
                state.isLoading = false
                state.error = ProductError(error: error)
                return .none
                
            // Diğer action case'leri...
            }
        }
        .ifLet(\.$productDetail, action: /Action.productDetail) {
            ProductDetailFeature()
        }
    }
}
```

Reducer'ın temel özellikleri:
- `Reducer` protokolüne uyarlar ve `body` özelliği sunarlar.
- Saf fonksiyonlardır - aynı giriş için her zaman aynı çıkışı üretirler.
- Side effect içermez, sadece etki (Effect) döndürebilir.
- State'i doğrudan değiştirir (mutating), ancak bu değişiklik sadece Reducer içinde gerçekleşir.
- Alt özellikleri için `.ifLet` kullanarak birleştirilebilir (composition).

### Effect (Yan Etkiler)

Effect'ler, asenkron işlemler, API çağrıları, zamanlayıcılar gibi yan etkilerin yönetilmesini sağlar:

```swift
// API'den veri çekme örneği
case .loadProducts:
    return .run { send in
        do {
            let products = try await productService.fetchProducts()
            await send(.productsResponse(.success(products)))
        } catch {
            await send(.productsResponse(.failure(error)))
        }
    }

// Zamanlayıcı örneği
case .startTimer:
    return .run { send in
        while true {
            try await Task.sleep(for: .seconds(1))
            await send(.timerTick)
        }
    }
    .cancellable(id: TimerID.self)
    
// İptal edilebilir Effect örneği
case .stopTimer:
    return .cancel(id: TimerID.self)
```

Effect'lerin temel özellikleri:
- Asenkron işlemleri yönetir (API çağrıları, DB işlemleri vb.).
- Task'lar halinde çalışır ve iptal edilebilir.
- Genellikle yeni Action'lar tetikler.
- Reducer'ın saf kalmasını sağlar.

### SwiftUI Entegrasyonu

```swift
struct HomeView: View {
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            // UI kodları...
            Button("Refresh") {
                viewStore.send(.refreshButtonTapped)
            }
        }
        .sheet(
            store: store.scope(
                state: \.$productDetail, 
                action: \.productDetail
            )
        ) { detailStore in
            ProductDetailView(store: detailStore)
        }
    }
}
```

SwiftUI entegrasyonunun özellikleri:
- `WithViewStore` ile state'e erişim sağlar.
- `send` metodu ile action'ları tetikler.
- `.sheet`, `.navigationDestination` vb. ile alt ekranlara geçiş sağlar.
- Key path kullanımı ile alt store'lara erişim sağlar.

## TCA'nın Avantajları

1. **Merkezi Durum Yönetimi**: Tüm uygulama durumu tek bir yerden yönetilir.
2. **Öngörülebilir Veri Akışı**: Tek yönlü veri akışı sayesinde hataları izlemek kolaydır.
3. **Test Edilebilirlik**: TestStore ile tüm durum değişiklikleri test edilebilir.
4. **Bağımlılık Enjeksiyonu**: Sıkı bağlantılardan kaçınmak için bağımlılık enjeksiyonu kullanılır.
5. **Yan Etki Yönetimi**: Asenkron işlemler ve yan etkiler kontrollü bir şekilde yönetilir.
6. **Composition**: Alt özellikleri kolayca birleştirebilir ve yeniden kullanabilirsiniz.

## Örnek Kullanım

Uygulama, bir ürün listesi görüntüleyen basit bir arayüz sunar:

1. Sayfa yüklendiğinde `onAppear` aksiyonu tetiklenir.
2. `loadProducts` aksiyonu ürünleri çekmek için servis katmanını kullanır.
3. Yükleme durumunda kullanıcıya bir yükleme göstergesi gösterilir.
4. Ürünler başarıyla yüklendiğinde liste görüntülenir.
5. Bir hata oluşursa, hata mesajı gösterilir ve yeniden deneme seçeneği sunulur.
6. Ürüne tıklandığında ürün detayı gösterilir ve sepete eklenebilir.

## Test Yaklaşımı

TCA mimarisi, TestStore ile kapsamlı test yazımını destekler:

```swift
func testFetchProductsSuccess() async {
    let testStore = TestStore(
        initialState: HomeFeature.State()
    ) {
        HomeFeature()
    } withDependencies: {
        $0.productService = MockProductService(fetchProductsResult: .success(mockProducts))
    }
    
    await testStore.send(.onAppear)
    await testStore.receive(.loadProducts)
    await testStore.receive(.productsResponse(.success(mockProducts)))
}
```

## Sonuç

TCA mimarisi, Swift ve SwiftUI ile modern iOS uygulama geliştirmede güçlü bir seçenektir. Durum yönetimi, yan etkiler ve test edilebilirlik konularında kapsamlı çözümler sunar ve ölçeklenebilir uygulamalar geliştirmek için idealdir. 