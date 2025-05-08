import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/plutoGrid/pluto_grid_home_view.dart';
import 'package:mediummerflutter/feature/plutoGrid/services/pluto_service.dart';
import 'package:pluto_grid/pluto_grid.dart';

mixin PlutoGridMixin on State<PlutoGridHomeView> {
  final PlutoService _plutoService = PlutoService();
  late PlutoGridStateManager stateManager;

  PlutoService get plutoService => _plutoService;
  PlutoGridStateManager get gridStateManager => stateManager;

  void onGridLoaded(PlutoGridOnLoadedEvent event) {
    stateManager = event.stateManager;
    stateManager.setShowColumnFilter(true);
    print('grid loaded');
  }

  void onGridChanged(PlutoGridOnChangedEvent event) {
    print(event.value);
    print('grid changed');
  }

  void toggleColumnFilter() {
    stateManager.setShowColumnFilter(!stateManager.showColumnFilter);
  }

  void onSelected(PlutoGridOnSelectedEvent event) {
    print(event.row);
    print('selected');
  }

  void onAddNewItem() {
    print('add new item');
  }
}
