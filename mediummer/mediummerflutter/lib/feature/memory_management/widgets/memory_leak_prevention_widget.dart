import 'package:flutter/material.dart';
import '../mixins/memory_management_mixin.dart';

/// Widget demonstrating memory leak prevention techniques
class MemoryLeakPreventionWidget extends StatefulWidget {
  const MemoryLeakPreventionWidget({super.key});

  @override
  State<MemoryLeakPreventionWidget> createState() => _MemoryLeakPreventionWidgetState();
}

class _MemoryLeakPreventionWidgetState extends State<MemoryLeakPreventionWidget> 
    with MemoryManagementMixin {
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Memory Leak Prevention Examples:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _performSafeAsyncOperation,
              child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Safe Async Operation'),
            ),
            const SizedBox(height: 16),
            
            const Text(
              '✅ Doğru Yaklaşımlar:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            
            const Text('• Async işlemlerde mounted kontrolü yapın'),
            const Text('• Mixin kullanarak kod tekrarını önleyin'),
            const Text('• ValueKey kullanarak widget\'ları optimize edin'),
            const Text('• Memory profiling araçları kullanın'),
            const SizedBox(height: 16),
            
            const Text(
              '❌ Yanlış Yaklaşımlar:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            
            const Text('• Mounted kontrolü yapmadan setState çağırma'),
            const Text('• Kontrolcüleri dispose etmeme'),
            const Text('• Stream subscription\'ları iptal etmeme'),
            const Text('• Büyük listelerde ListView yerine Column kullanma'),
            const SizedBox(height: 16),
            
            const Text(
              '📋 Ne Zaman Kullanılmalı:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            
            const Text('• Async işlemler yapan tüm widget\'larda'),
            const Text('• Sayfalar arası navigation sık olan uygulamalarda'),
            const Text('• Long-running işlemler varken'),
            const Text('• API çağrıları yapan widget\'larda'),
            const Text('• Production uygulamalarda her zaman'),
          ],
        ),
      ),
    );
  }
  
  Future<void> _performSafeAsyncOperation() async {
    safeSateSet(() => _isLoading = true);
    
    await safeAsyncOperation(() async {
      await Future<void>.delayed(const Duration(seconds: 2));
    });
    
    safeSateSet(() => _isLoading = false);
  }
}