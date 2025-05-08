import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/plutoGrid/services/pluto_service.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/constants/pluto_grid_constants.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/custom_pluto_configuration.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/mixins/pluto_grid_mixin.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/pluto_column_helper.dart';
import 'package:mediummerflutter/feature/plutoGrid/widgets/summary_card.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoGridHomeView extends StatefulWidget {
  const PlutoGridHomeView({super.key});

  @override
  State<PlutoGridHomeView> createState() => _PlutoGridHomeViewState();
}

class _PlutoGridHomeViewState extends State<PlutoGridHomeView>
    with PlutoGridMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PlutoGridConstants.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(PlutoGridConstants.filterIcon),
            onPressed: toggleColumnFilter,
          ),
          IconButton(
            icon: const Icon(PlutoGridConstants.addIcon),
            onPressed: onAddNewItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(PlutoGridConstants.defaultPadding),
        child: Column(
          children: [
            // Summary cards
            _Header(plutoService: plutoService),
            const SizedBox(height: PlutoGridConstants.defaultPadding),
            // Main grid
            Expanded(
              child: 
              PlutoGrid(
                columns: PlutoColumnHelper.getColumns(),
                rows: PlutoColumnHelper.getProductRows(),
                onChanged: onGridChanged,
                onLoaded: onGridLoaded,
                onSelected: onSelected,
                mode: PlutoGridMode.multiSelect,
                configuration: CustomPlutoConfiguration(context: context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required PlutoService plutoService, super.key})
    : _plutoService = plutoService;

  final PlutoService _plutoService;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SummaryCard(
          title: PlutoGridConstants.totalProductsTitle,
          value: _plutoService.products.length.toString(),
          icon: PlutoGridConstants.totalProductsIcon,
          color: PlutoGridConstants.totalProductsColor,
        ),
        const SizedBox(width: PlutoGridConstants.defaultPadding),
        const SummaryCard(
          title: PlutoGridConstants.lowStockItemsTitle,
          value: PlutoGridConstants.lowStockCount,
          icon: PlutoGridConstants.lowStockIcon,
          color: PlutoGridConstants.lowStockColor,
        ),
        const SizedBox(width: PlutoGridConstants.defaultPadding),
        const SummaryCard(
          title: PlutoGridConstants.totalValueTitle,
          value: PlutoGridConstants.totalValueAmount,
          icon: PlutoGridConstants.totalValueIcon,
          color: PlutoGridConstants.totalValueColor,
        ),
      ],
    );
  }
}
