# Mediator Messaging App

Gerçek bir mesajlaşma uygulaması olarak geliştirilmiş, **Mediator Pattern** kullanarak bileşenler arası iletişimi merkezi olarak yöneten Flutter projesi.

## 🚀 Uygulama Özellikleri

### 💬 Mesajlaşma Sistemi
- **Gerçek zamanlı mesajlaşma** - Kullanıcılar arası anlık iletişim
- **Sohbet odaları** - Farklı konular için ayrı sohbet alanları
- **Kullanıcı yönetimi** - Profil bilgileri ve avatar desteği
- **Typing indicators** - Kullanıcının yazdığını gösteren göstergeler
- **Mesaj geçmişi** - Tüm mesajların saklanması ve görüntülenmesi

### 🔄 Mediator Pattern Uygulaması
Bu uygulama, Mediator Pattern'i gerçek bir proje üzerinde gösterir:

- **Merkezi İletişim**: Tüm bileşenler mediator üzerinden haberleşir
- **Loose Coupling**: Bileşenler birbirini tanımaz, sadece mediator'ı bilir
- **Event-Driven**: Olay tabanlı iletişim sistemi
- **Scalable**: Yeni özellikler kolayca eklenebilir

## 🏗️ Teknik Mimari

### Core Components
```
MessagingSystem (Facade)
    ↓
ConcreteMessagingMediator (Mediator)
    ↓
┌─────────────────────────────────────┐
│  ChatRoomManager  │  UserManager   │
│                   │                │
│  Notification     │  MessageLogger │
│  Service          │                │
└─────────────────────────────────────┘
```

### Data Models
- **User**: Kullanıcı bilgileri (id, name, avatar)
- **Message**: Mesaj verileri (content, sender, timestamp, roomId)
- **ChatRoom**: Sohbet odası bilgileri (name, participants, createdAt)

### Mediator Events
- `userJoined`, `userLeft` - Kullanıcı giriş/çıkış olayları
- `messageSent`, `messageReceived` - Mesaj gönderme/alma olayları
- `chatRoomCreated`, `chatRoomDeleted` - Oda oluşturma/silme olayları
- `userTyping`, `userStoppedTyping` - Yazma göstergeleri
- `messageRead`, `notificationSent` - Durum ve bildirim olayları

## 🎯 Kullanım Senaryoları

### 1. Kullanıcı Sohbet Odasına Katılır
```
User → UserManager.joinChatRoom() → Mediator.notify(userJoined) 
→ ChatRoomManager.addUserToRoom() + NotificationService.notifyUserJoined()
```

### 2. Mesaj Gönderilir
```
User → MessagingSystem.sendMessage() → Mediator.notify(messageSent)
→ MessageLogger.logMessage() + NotificationService.notifyNewMessage() + ChatRoomManager.addMessageToRoom()
```

### 3. Typing Indicator Başlar
```
User types → UserManager.startTyping() → Mediator.notify(userTyping)
→ NotificationService.notifyUserTyping() → UI updates
```

## 🔧 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code

### Kurulum
```bash
# Projeyi klonlayın
git clone <repository-url>
cd mediummerflutter

# Bağımlılıkları yükleyin
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

## 📱 Uygulama Arayüzü

### Ana Ekran
- **Sol Sidebar**: Kullanıcı profili ve sohbet odaları listesi
- **Ana Alan**: Seçili odadaki mesajlar ve yazma alanı
- **Üst Bar**: Oda adı, kullanıcı profili ve yeni oda oluşturma

### Özellikler
- **Responsive Design**: Farklı ekran boyutlarına uyumlu
- **Material Design 3**: Modern ve kullanıcı dostu arayüz
- **Real-time Updates**: Anlık güncellenen mesajlar ve durumlar
- **Interactive Elements**: Tıklanabilir odalar, mesaj gönderme, profil düzenleme

## 🎨 UI Bileşenleri

### Chat Room List
- Oda adı ve katılımcı sayısı
- Seçili oda vurgulaması
- Tıklanabilir liste öğeleri

### Message Display
- Gönderen kullanıcı bilgisi
- Mesaj içeriği ve zaman damgası
- Kendi mesajlar için farklı stil
- Avatar ve kullanıcı adı gösterimi

### Input Area
- Mesaj yazma alanı
- Gönderme butonu
- Typing indicator tetikleme

## 🚀 Gelecek Özellikler

### Planlanan Geliştirmeler
- **Push Notifications**: Gerçek zamanlı bildirimler
- **File Sharing**: Dosya ve resim paylaşımı
- **Voice Messages**: Ses mesajları
- **Group Management**: Grup yönetimi ve moderasyon
- **Search Functionality**: Mesaj ve kullanıcı arama
- **User Authentication**: Kullanıcı girişi ve güvenlik

### Teknik İyileştirmeler
- **Database Integration**: Kalıcı veri saklama
- **WebSocket Support**: Gerçek zamanlı bağlantı
- **State Management**: Provider/Riverpod entegrasyonu
- **Testing**: Unit ve widget testleri
- **Performance**: Mesaj listesi optimizasyonu

## 💡 Mediator Pattern'in Avantajları

### Önceki Durum (Karmaşık İletişim)
```
UserManager ↔ ChatRoomManager ↔ NotificationService ↔ MessageLogger
     ↕              ↕                ↕                ↕
  Direct references create tight coupling and complexity
```

### Sonraki Durum (Mediator ile)
```
UserManager → Mediator ← ChatRoomManager
     ↓           ↓           ↓
NotificationService → Mediator ← MessageLogger
```

**Faydalar:**
- ✅ **Loose Coupling**: Bileşenler birbirini tanımaz
- ✅ **Centralized Control**: Tüm iletişim tek yerde
- ✅ **Easy Maintenance**: Değişiklikler sadece mediator'da
- ✅ **Component Reusability**: Bileşenler farklı sistemlerde kullanılabilir
- ✅ **Clear Communication Flow**: İletişim akışı net ve takip edilebilir

## 🔍 Kod Örnekleri

### Mediator Interface
```dart
abstract class MessagingMediator {
  void notify({
    required Object sender,
    required MessagingEvent event,
    Map<String, dynamic>? data,
  });
}
```

### Component Communication
```dart
// UserManager sends event through mediator
_mediator.notify(
  sender: this,
  event: MessagingEvent.userJoined,
  data: {'user': user, 'chatRoomId': chatRoomId},
);
```

### Event Handling
```dart
void _handleUserJoined(Object sender, Map<String, dynamic>? data) {
  final user = data!['user'] as User;
  final chatRoomId = data['chatRoomId'] as String;
  
  _chatRoomManager?.addUserToRoom(chatRoomId, user);
  _messageLogger?.logEvent('User ${user.name} joined chat room $chatRoomId');
  _notificationService?.notifyUserJoined(user, chatRoomId);
}
```

## 📚 Öğrenme Kaynakları

- [Mediator Pattern - Wikipedia](https://en.wikipedia.org/wiki/Mediator_pattern)
- [Flutter Architecture Patterns](https://flutter.dev/docs/development/data-and-backend/state-mgmt/patterns)
- [Design Patterns - Gang of Four](https://en.wikipedia.org/wiki/Design_Patterns)

## 🤝 Katkıda Bulunma

Bu proje açık kaynak kodludur. Katkılarınızı bekliyoruz:

1. **Fork** yapın
2. **Feature branch** oluşturun (`git checkout -b feature/AmazingFeature`)
3. **Commit** yapın (`git commit -m 'Add some AmazingFeature'`)
4. **Push** yapın (`git push origin feature/AmazingFeature`)
5. **Pull Request** oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

**Happy Messaging! 💬**

Mediator Pattern'in gücünü gerçek bir uygulama üzerinde deneyimleyin ve modern mesajlaşma sistemlerinin nasıl tasarlandığını öğrenin.
