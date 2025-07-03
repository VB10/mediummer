import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/memory_management/mixins/memory_management_mixin.dart';

/// Example of WeakReference usage for memory management
class WeakReferenceWidget extends StatefulWidget {
  const WeakReferenceWidget({super.key});

  @override
  State<WeakReferenceWidget> createState() => _WeakReferenceWidgetState();
}

class _WeakReferenceWidgetState extends State<WeakReferenceWidget>
    with MemoryManagementMixin {
  WeakReferenceExample? _weakRefExample;
  ExpensiveObject? _expensiveObject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WeakReference Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _createExpensiveObject,
                    child: const Text('Create Object'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _useWeakReference,
                    child: const Text('Use WeakRef'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _forceGarbageCollection,
                    child: const Text('Force GC'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Object Status: ${_getObjectStatus()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '✅ WeakReference Avantajları:',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            const Text("• Circular reference'ları önler"),
            const Text("• Garbage Collection'ı engellemez"),
            const Text('• Memory leak riskini azaltır'),
            const Text('• Cache implementasyonlarında ideal'),
            const SizedBox(height: 16),
            const Text(
              '⚠️ Dikkat Edilmesi Gerekenler:',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text('• Object null olabilir, kontrol edin'),
            const Text('• Strong reference tutmayın'),
            const Text("• UI update'lerinde dikkatli kullanın"),
            const SizedBox(height: 16),
            const Text(
              '📋 Ne Zaman Kullanılmalı:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text('• Cache implementasyonlarında'),
            const Text(
                "• Observer pattern'de circular reference'ları önlemek için"),
            const Text('• Parent-child widget ilişkilerinde'),
            const Text('• Singleton nesnelere referans tutarken'),
            const Text('• Memory-sensitive uygulamalarda'),
          ],
        ),
      ),
    );
  }

  void _createExpensiveObject() {
    safeSateSet(() {
      _expensiveObject = ExpensiveObject(
          'Expensive Data ${DateTime.now().millisecondsSinceEpoch}');
      _weakRefExample = WeakReferenceExample(_expensiveObject!);
    });
  }

  void _useWeakReference() {
    if (_weakRefExample != null) {
      _weakRefExample!.doSomething();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WeakReference kullanıldı')),
      );
    }
  }

  void _forceGarbageCollection() {
    safeSateSet(() {
      _expensiveObject = null; // Strong reference'ı kaldır
    });

    // Garbage collection'ı tetikle (development için)
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 100), () {
        safeSateSet(() {
          // UI'ı güncelle
        });
      });
    }
  }

  String _getObjectStatus() {
    if (_weakRefExample == null) return 'Not created';

    final object = _weakRefExample!.getTarget();
    if (object != null) {
      return 'Alive: ${object.data}';
    } else {
      return 'Garbage collected';
    }
  }
}

/// WeakReference example implementation
class WeakReferenceExample {
  WeakReferenceExample(ExpensiveObject object)
      : _weakRef = WeakReference<ExpensiveObject>(object);
  final WeakReference<ExpensiveObject> _weakRef;

  void doSomething() {
    final object = _weakRef.target;
    if (object != null) {
      debugPrint('Using object: ${object.data}');
      object.performExpensiveOperation();
    } else {
      debugPrint('Object has been garbage collected');
    }
  }

  ExpensiveObject? getTarget() => _weakRef.target;
}

/// Example of an expensive object that might be garbage collected
class ExpensiveObject {
  ExpensiveObject(this.data) : _expensiveData = List.generate(1000, (i) => i);
  final String data;
  final List<int> _expensiveData;

  void performExpensiveOperation() {
    // Simüle edilmiş pahalı işlem
    _expensiveData.fold(0, (sum, element) => sum + element);
    debugPrint('Expensive operation completed for: $data');
  }

  @override
  String toString() => 'ExpensiveObject($data)';
}
