import 'package:mediummerflutter/feature/plutoGrid/services/models/pluto_model.dart';

class PlutoService {
  // Simulated database of products
  final List<PlutoProduct> products = [
    PlutoProduct(
      id: 'P001',
      name: 'Laptop Pro X1',
      category: 'Electronics',
      price: 1299.99,
      stockQuantity: 50,
      lastRestocked: DateTime(2024, 3, 15),
      supplier: 'TechSuppliers Inc.',
    ),
    PlutoProduct(
      id: 'P002',
      name: 'Wireless Mouse',
      category: 'Accessories',
      price: 29.99,
      stockQuantity: 200,
      lastRestocked: DateTime(2024, 3, 10),
      supplier: 'AccessoryWorld',
    ),
    // Add more sample products as needed
  ];

  // Update product data
  void updateProduct(PlutoProduct event) {
    // In a real application, this would update the database
  }
}
