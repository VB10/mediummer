import 'package:flutter/material.dart';

class PlutoGridConstants {
  // App Bar
  static const String appBarTitle = 'Inventory Management';

  // Summary Cards
  static const String totalProductsTitle = 'Total Products';
  static const String lowStockItemsTitle = 'Low Stock Items';
  static const String totalValueTitle = 'Total Value';

  // Placeholder Values
  static const String lowStockCount = '2';
  static const String totalValueAmount = r'$15,000';

  // Icons
  static const IconData totalProductsIcon = Icons.inventory_2;
  static const IconData lowStockIcon = Icons.warning;
  static const IconData totalValueIcon = Icons.attach_money;
  static const IconData filterIcon = Icons.filter_list;
  static const IconData addIcon = Icons.add;

  // Colors
  static const Color totalProductsColor = Colors.blue;
  static const Color lowStockColor = Colors.orange;
  static const Color totalValueColor = Colors.green;

  // Dimensions
  static const double cardElevation = 4;
  static const double defaultPadding = 16;
  static const double iconSpacing = 8;
  static const double titleFontSize = 16;
  static const double valueFontSize = 24;
  static const double gridBorderRadius = 10;
  static const double cellFontSize = 14;
}
