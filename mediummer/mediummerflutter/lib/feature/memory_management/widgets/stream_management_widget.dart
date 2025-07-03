import 'dart:async';
import 'package:flutter/material.dart';
import '../mixins/memory_management_mixin.dart';

/// Widget demonstrating stream and controller management
class StreamManagementWidget extends StatefulWidget {
  const StreamManagementWidget({super.key});

  @override
  State<StreamManagementWidget> createState() => _StreamManagementWidgetState();
}

class _StreamManagementWidgetState extends State<StreamManagementWidget> 
    with ControllerManagementMixin, MemoryManagementMixin {
  
  late StreamController<int> _streamController;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }
  
  void _initializeStream() {
    _streamController = StreamController<int>();
    
    final subscription = _streamController.stream.listen((value) {
      safeSateSet(() {
        _counter = value;
      });
    });
    
    registerDisposable(DisposableStreamSubscription(subscription));
  }
  
  void _addToStream() {
    _streamController.add(_counter + 1);
  }
  
  @override
  void dispose() {
    _streamController.close();
    super.dispose();
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
              'Stream Management Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Text('Counter: $_counter'),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _addToStream,
              child: const Text('Add to Stream'),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Önemli: Stream subscription mixin ile otomatik cancel edilir!',
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
            
            const Text('• Real-time veri akışları kullanırken'),
            const Text('• WebSocket bağlantıları yönetirken'),
            const Text('• Event-driven programlama yaparken'),
            const Text('• Async veri işlemleri sırasında'),
            const Text('• Observer pattern implementasyonunda'),
          ],
        ),
      ),
    );
  }
}