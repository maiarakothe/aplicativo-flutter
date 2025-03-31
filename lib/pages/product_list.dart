import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awidgets/general/a_table.dart';

class ShowProductPage extends StatefulWidget {
  final ValueNotifier<List<Map<String, String>>> productsNotifier;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const ShowProductPage({
    super.key,
    required this.productsNotifier,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _ShowProductPageState createState() => _ShowProductPageState();
}

class _ShowProductPageState extends State<ShowProductPage> {
  final GlobalKey<ATableState<Map<String, String>>> _tableKey = GlobalKey<ATableState<Map<String, String>>>();

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

  Future<List<Map<String, String>>> _loadProducts(int limit, int offset) async {
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
      body: ATable<Map<String, String>>(
        key: _tableKey,
        columns: [
          ATableColumn(
            title: AppLocalizations.of(context).name,
            cellBuilder: (context, width, item) => Text(item['name'] ?? ''),
          ),
          ATableColumn(
            title: AppLocalizations.of(context).price,
            cellBuilder: (context, width, item) => Text("R\$ ${item['price']}"),
          ),
          ATableColumn(
            title: AppLocalizations.of(context).image,
            cellBuilder: (context, width, item) {
              return item['image'] != null && item['image']!.isNotEmpty
                  ? Image.network(
                item['image']!,
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
                    onPressed: () => widget.onEdit(widget.productsNotifier.value.indexOf(item)),
                  ),
                ),
                Tooltip(
                  message: AppLocalizations.of(context).delete,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onDelete(widget.productsNotifier.value.indexOf(item)),
                  ),
                ),
              ],
            ),
          ),
        ],
        loadItems: _loadProducts,
        emptyMessage: AppLocalizations.of(context).noProducts,
      ),
    );
  }
}