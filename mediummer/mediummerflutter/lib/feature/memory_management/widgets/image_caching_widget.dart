import 'package:flutter/material.dart';
import '../mixins/memory_management_mixin.dart';

/// Widget demonstrating efficient image loading and caching
class ImageCachingWidget extends StatefulWidget {
  const ImageCachingWidget({super.key});

  @override
  State<ImageCachingWidget> createState() => _ImageCachingWidgetState();
}

class _ImageCachingWidgetState extends State<ImageCachingWidget> 
    with MemoryManagementMixin {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Image Caching Examples:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            const Text('✅ Doğru Yaklaşım:'),
            const SizedBox(height: 8),
            Image.network(
              'https://via.placeholder.com/300x200',
              width: 300,
              height: 200,
              cacheWidth: 300,
              cacheHeight: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                ElevatedButton(
                  onPressed: clearImageCache,
                  child: const Text('Clear Cache'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: optimizeImageCache,
                  child: const Text('Optimize Cache'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Tip: cacheWidth ve cacheHeight kullanarak bellek kullanımını optimize edin',
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
            
            const Text('• Çok sayıda resim gösteren uygulamalarda'),
            const Text('• Galeri, sosyal medya uygulamalarında'),
            const Text('• Büyük resim dosyaları ile çalışırken'),
            const Text('• Liste içinde resimler gösterirken'),
            const Text('• Bellek kullanımını optimize etmek istediğinizde'),
          ],
        ),
      ),
    );
  }
}