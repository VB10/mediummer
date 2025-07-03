import 'dart:async';
import 'package:flutter/material.dart';
import '../mixins/memory_management_mixin.dart';

/// Widget demonstrating controller disposal best practices
class ControllerDisposalWidget extends StatefulWidget {
  const ControllerDisposalWidget({super.key});

  @override
  State<ControllerDisposalWidget> createState() => _ControllerDisposalWidgetState();
}

class _ControllerDisposalWidgetState extends State<ControllerDisposalWidget> 
    with SingleTickerProviderStateMixin, ControllerManagementMixin {
  
  late DisposableTextController _textController;
  late DisposableScrollController _scrollController;
  late DisposableAnimationController _animationController;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }
  
  void _initializeControllers() {
    _textController = DisposableTextController();
    _scrollController = DisposableScrollController();
    _animationController = DisposableAnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Register controllers for automatic disposal
    registerDisposable(_textController);
    registerDisposable(_scrollController);
    registerDisposable(_animationController);
    
    // Create timer and wrap it for disposal
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Timer operations
      }
    });
    
    if (_timer != null) {
      registerDisposable(DisposableTimer(_timer!));
    }
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
              'Controller Disposal Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text Controller Example',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Önemli: Mixin kullanarak tüm kontrolcüler otomatik dispose edilir!',
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
            
            const Text('• StatefulWidget kullanırken'),
            const Text('• TextEditingController, ScrollController gibi kontrolcüler kullanırken'),
            const Text('• AnimationController ile animasyon yaparken'),
            const Text('• Timer veya periyodik işlemler kullanırken'),
            const Text('• Sayfalar arası navigation sık yapıldığında'),
          ],
        ),
      ),
    );
  }
}