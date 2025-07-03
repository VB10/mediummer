import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/accordion_section_widget.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/controller_disposal_widget.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/image_caching_widget.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/large_list_widget.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/memory_leak_prevention_widget.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/stream_management_widget.dart';
import 'package:mediummerflutter/feature/memory_management/widgets/weak_reference_widget.dart';

/// Flutter Memory Management Best Practices Examples
/// Clean and organized main page with accordion layout
class MemoryManagementExamples extends StatefulWidget {
  const MemoryManagementExamples({super.key});

  @override
  State<MemoryManagementExamples> createState() => _MemoryManagementExamplesState();
}

class _MemoryManagementExamplesState extends State<MemoryManagementExamples> {
  int? _expandedIndex;
  
  void _onExpansionChanged(int index, bool isExpanded) {
    setState(() {
      _expandedIndex = isExpanded ? index : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Management Examples'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccordionSectionWidget(
              title: '1. Kaynakların Serbest Bırakılması',
              initiallyExpanded: _expandedIndex == 0,
              onExpansionChanged: (isExpanded) => _onExpansionChanged(0, isExpanded),
              child: const ControllerDisposalWidget(),
            ),
            const SizedBox(height: 16),
            
            AccordionSectionWidget(
              title: '2. Verimli Görüntü Yükleme ve Önbellekleme',
              initiallyExpanded: _expandedIndex == 1,
              onExpansionChanged: (isExpanded) => _onExpansionChanged(1, isExpanded),
              child: const ImageCachingWidget(),
            ),
            const SizedBox(height: 16),
            
            AccordionSectionWidget(
              title: '3. Akış ve Kontrolcü Yönetimi',
              initiallyExpanded: _expandedIndex == 2,
              onExpansionChanged: (isExpanded) => _onExpansionChanged(2, isExpanded),
              child: const StreamManagementWidget(),
            ),
            const SizedBox(height: 16),
            
            AccordionSectionWidget(
              title: '4. Büyük Listelerin Yönetimi',
              initiallyExpanded: _expandedIndex == 3,
              onExpansionChanged: (isExpanded) => _onExpansionChanged(3, isExpanded),
              child: const LargeListWidget(),
            ),
            const SizedBox(height: 16),
            
            AccordionSectionWidget(
              title: '5. Bellek Sızıntılarını Önleme',
              initiallyExpanded: _expandedIndex == 4,
              onExpansionChanged: (isExpanded) => _onExpansionChanged(4, isExpanded),
              child: const MemoryLeakPreventionWidget(),
            ),
            const SizedBox(height: 16),
            
            AccordionSectionWidget(
              title: '6. WeakReference Kullanımı',
              initiallyExpanded: _expandedIndex == 5,
              onExpansionChanged: (isExpanded) => _onExpansionChanged(5, isExpanded),
              child: const WeakReferenceWidget(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}