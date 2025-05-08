class PlutoProduct {
  PlutoProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stockQuantity,
    required this.lastRestocked,
    required this.supplier,
  });

  // Create Product from Map
  factory PlutoProduct.fromMap(Map<String, dynamic> map) {
    return PlutoProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: map['price'] as double,
      stockQuantity: map['stockQuantity'] as int,
      lastRestocked: map['lastRestocked'] as DateTime,
      supplier: map['supplier'] as String,
    );
  }
  final String id;
  final String name;
  final String category;
  final double price;
  final int stockQuantity;
  final DateTime lastRestocked;
  final String supplier;

  // Convert Product to Map for PlutoGrid
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stockQuantity': stockQuantity,
      'lastRestocked': lastRestocked,
      'supplier': supplier,
    };
  }
}
