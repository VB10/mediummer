import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/constants/pluto_grid_constants.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: PlutoGridConstants.cardElevation,
        child: Padding(
          padding: const EdgeInsets.all(PlutoGridConstants.defaultPadding),
          child: Column(
            children: [
              Icon(icon, color: color),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: PlutoGridConstants.titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: PlutoGridConstants.iconSpacing),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: PlutoGridConstants.valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
