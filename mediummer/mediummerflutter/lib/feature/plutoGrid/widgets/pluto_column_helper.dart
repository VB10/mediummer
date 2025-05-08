import 'package:mediummerflutter/feature/plutoGrid/services/models/pluto_cell_field.dart';
import 'package:mediummerflutter/feature/plutoGrid/services/pluto_service.dart';
import 'package:pluto_grid/pluto_grid.dart';

final class PlutoColumnHelper {
  // Get all products as PlutoGrid rows
  static List<PlutoRow> getProductRows() {
    final products = PlutoService().products;
    return products.map((product) {
      return PlutoRow(
        cells: {
          PlutoCellField.id.name: PlutoCell(value: product.id),
          PlutoCellField.name.name: PlutoCell(value: product.name),
          PlutoCellField.category.name: PlutoCell(value: product.category),
          PlutoCellField.price.name: PlutoCell(value: product.price),
          PlutoCellField.stockQuantity.name: PlutoCell(
            value: product.stockQuantity,
          ),
          PlutoCellField.lastRestocked.name: PlutoCell(
            value: product.lastRestocked,
          ),
          PlutoCellField.supplier.name: PlutoCell(value: product.supplier),
        },
      );
    }).toList();
  }

  // Get column definitions for PlutoGrid
  static List<PlutoColumn> getColumns() {
    return [
      PlutoColumn(
        title: 'ID',
        field: PlutoCellField.id.name,
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'Name',
        field: PlutoCellField.name.name,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Category',
        field: PlutoCellField.category.name,
        type: PlutoColumnType.select([
          'Electronics',
          'Accessories',
          'Furniture',
          'Office Supplies',
        ]),
        width: 150,
      ),
      PlutoColumn(
        title: 'Price',
        field: PlutoCellField.price.name,
        type: PlutoColumnType.number(format: '#,##0.00', negative: false),
        width: 120,
      ),
      PlutoColumn(
        title: 'Stock',
        field: PlutoCellField.stockQuantity.name,
        type: PlutoColumnType.number(format: '#,##0', negative: false),
        width: 100,
      ),
      PlutoColumn(
        title: 'Last Restocked',
        field: PlutoCellField.lastRestocked.name,
        type: PlutoColumnType.date(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Supplier',
        field: PlutoCellField.supplier.name,
        type: PlutoColumnType.text(),
      ),
    ];
  }
}
