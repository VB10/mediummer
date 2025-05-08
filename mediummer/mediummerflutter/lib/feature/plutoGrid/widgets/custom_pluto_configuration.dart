import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/constants/pluto_grid_constants.dart';
import 'package:pluto_grid/pluto_grid.dart';

final class CustomPlutoConfiguration extends PlutoGridConfiguration {
  CustomPlutoConfiguration({required BuildContext context})
    : super(
        style: PlutoGridStyleConfig(
          gridBorderColor: Colors.grey.shade300,
          gridBorderRadius: BorderRadius.circular(
            PlutoGridConstants.gridBorderRadius,
          ),
          columnTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          activatedColor: Theme.of(context).colorScheme.onPrimary,
          activatedBorderColor: Theme.of(context).colorScheme.onPrimary,
          oddRowColor: Colors.grey.shade50,
        ),
      );
}
