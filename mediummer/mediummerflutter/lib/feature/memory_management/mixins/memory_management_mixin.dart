import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

/// Memory Management Mixin for common memory operations
mixin MemoryManagementMixin<T extends StatefulWidget> on State<T> {
  
  /// Safe async operation with mounted check
  Future<void> safeAsyncOperation(Future<void> Function() operation) async {
    try {
      await operation();
    } catch (e) {
      if (mounted) {
        debugPrint('Async operation error: $e');
      }
    }
  }
  
  /// Safe setState with mounted check
  void safeSateSet(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }
  
  /// Print memory usage for debugging
  void printMemoryUsage() {
    if (Platform.isAndroid || Platform.isIOS) {
      debugPrint('Memory tracking - Platform: ${Platform.operatingSystem}');
    }
  }
  
  /// Clear image cache
  void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
  
  /// Optimize image cache settings
  void optimizeImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
  }
}

/// Controller Management Mixin for disposing controllers
mixin ControllerManagementMixin<T extends StatefulWidget> on State<T> {
  final List<Disposable> _disposables = [];
  
  /// Register a disposable resource
  void registerDisposable(Disposable disposable) {
    _disposables.add(disposable);
  }
  
  /// Dispose all registered resources
  void disposeAllResources() {
    for (final disposable in _disposables) {
      disposable.dispose();
    }
    _disposables.clear();
  }
  
  @override
  void dispose() {
    disposeAllResources();
    super.dispose();
  }
}

/// Interface for disposable resources
abstract class Disposable {
  void dispose();
}

/// Wrapper for TextEditingController
class DisposableTextController extends TextEditingController implements Disposable {
  DisposableTextController({super.text});
}

/// Wrapper for ScrollController
class DisposableScrollController extends ScrollController implements Disposable {
  DisposableScrollController({super.initialScrollOffset});
}

/// Wrapper for AnimationController
class DisposableAnimationController extends AnimationController implements Disposable {
  DisposableAnimationController({
    required super.duration,
    required super.vsync,
  });
}

/// Wrapper for StreamSubscription
class DisposableStreamSubscription<T> implements Disposable {
  final StreamSubscription<T> _subscription;
  
  DisposableStreamSubscription(this._subscription);
  
  @override
  void dispose() {
    _subscription.cancel();
  }
}

/// Wrapper for Timer
class DisposableTimer implements Disposable {
  final Timer _timer;
  
  DisposableTimer(this._timer);
  
  @override
  void dispose() {
    _timer.cancel();
  }
}