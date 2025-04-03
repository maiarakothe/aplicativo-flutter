import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awidgets/general/a_table.dart';
import '../models/product_registration.dart';

class ShowProductPage extends StatefulWidget {
  final ValueNotifier<List<ProductRegistrationData>> productsNotifier;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const ShowProductPage({
    super.key,
    required this.productsNotifier,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ShowProductPage> {
  final GlobalKey<ATableState<ProductRegistrationData>> _tableKey =
  GlobalKey<ATableState<ProductRegistrationData>>();

  @override
  void initState() {
    super.initState();
    widget.productsNotifier.addListener(_reloadTable);
  }

  @override
  void dispose() {
    widget.productsNotifier.removeListener(_reloadTable);
    super.dispose();
  }

  void _reloadTable() {
    if (_tableKey.currentState != null) {
      _tableKey.currentState!.reload();
    }
  }

  Future<List<ProductRegistrationData>> _loadProducts(int limit, int offset) async {
    return widget.productsNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(AppLocalizations.of(context).products),
        ),
      ),
      body: ATable<ProductRegistrationData>(
        key: _tableKey,
        columns: [
          ATableColumn(
            title: AppLocalizations.of(context).name,
            cellBuilder: (context, width, item) => Text(item.name),
          ),
          ATableColumn(
            title: AppLocalizations.of(context)!.price,
            cellBuilder: (context, width, item) =>
                Text("R\$ ${item.value.toStringAsFixed(2)}"),
          ),
          ATableColumn(
            title: AppLocalizations.of(context).image,
            cellBuilder: (context, width, item) {
              return item.url.isNotEmpty
                  ? Image.network(
                item.url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 50),
              )
                  : Icon(Icons.image, size: 50);
            },
          ),
          ATableColumn(
            cellBuilder: (context, width, item) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: AppLocalizations.of(context).edit,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () =>
                        widget.onEdit(widget.productsNotifier.value.indexOf(item)),
                  ),
                ),
                Tooltip(
                  message: AppLocalizations.of(context).delete,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        widget.onDelete(widget.productsNotifier.value.indexOf(item)),
                  ),
                ),
              ],
            ),
          ),
        ],
        loadItems: _loadProducts,
        emptyMessage: AppLocalizations.of(context)!.noProducts,
      ),
    );
  }
}
