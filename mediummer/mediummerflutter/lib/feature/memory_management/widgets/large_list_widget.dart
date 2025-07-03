import 'package:flutter/material.dart';
import '../mixins/memory_management_mixin.dart';

/// Widget demonstrating large list management with lazy loading
class LargeListWidget extends StatefulWidget {
  const LargeListWidget({super.key});

  @override
  State<LargeListWidget> createState() => _LargeListWidgetState();
}

class _LargeListWidgetState extends State<LargeListWidget> 
    with ControllerManagementMixin {
  
  final List<String> _items = List.generate(10000, (index) => 'Item $index');
  late DisposableScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = DisposableScrollController();
    registerDisposable(_scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Large List Management Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            const Text('✅ Doğru Yaklaşım: ListView.builder kullanın'),
            const SizedBox(height: 8),
            
            SizedBox(
              height: 200,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: ValueKey(_items[index]),
                    leading: const Icon(Icons.list),
                    title: Text(_items[index]),
                    subtitle: Text('Index: $index'),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Tip: ListView.builder tembel yükleme yapar, sadece görünen öğeler bellekte tutulur',
              style: TextStyle(
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            
            const Text(
              '📋 Ne Zaman Kullanılmalı:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            
            const Text('• 100+ öğeli listeler görüntülerken'),
            const Text('• Sonsuz scroll (infinite scroll) implementasyonunda'),
            const Text('• Chat uygulamalarında mesaj listelerinde'),
            const Text('• E-ticaret ürün listelerinde'),
            const Text('• Performans optimizasyonu gerektiğinde'),
          ],
        ),
      ),
    );
  }
}