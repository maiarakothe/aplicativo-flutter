import 'package:awidgets/general/a_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:teste/configs.dart';

import '../api/api.dart';
import '../api/api_product.dart';
import '../core/app_drawer.dart';
import '../models/product_registration.dart';
import '../theme_toggle_button.dart';

class ShowProductPage extends StatefulWidget {
  final void Function(Locale locale) changeLanguage;

  const ShowProductPage({super.key, required this.changeLanguage});

  @override
  State<ShowProductPage> createState() => _ShowProductPageState();
}

class _ShowProductPageState extends State<ShowProductPage> {
  final _tableKey = GlobalKey<ATableState<ProductRegistrationData>>();
  final ValueNotifier<List<ProductRegistrationData>> _productsNotifier =
      ValueNotifier([]);
  final ProductAPI _api = ProductAPI(API());

  @override
  void initState() {
    super.initState();
    _productsNotifier.addListener(_reloadTable);
    _loadProducts();
  }

  @override
  void dispose() {
    _productsNotifier.removeListener(_reloadTable);
    super.dispose();
  }

  void _reloadTable() {
    _tableKey.currentState?.reload();
  }

  Future<void> _loadProducts() async {
    try {
      final result = await _api.getAllProducts(accountId: selectedAccount!.id);
      final loadedProducts = result
          .map((json) => ProductRegistrationData.fromJson(json))
          .toList();
      _productsNotifier.value = loadedProducts;
    } catch (e) {
      _showErrorSnackBar('Erro ao carregar produtos: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _editProduct(ProductRegistrationData product) {
    Navigator.pushNamed(
      context,
      '/product_registration',
      arguments: {'productId': product.id},
    ).then((_) {
      _loadProducts();
    });
  }

  void _confirmDelete(int index) {
    final product = _productsNotifier.value[index];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).confirmDelete),
        content: Text(AppLocalizations.of(context).areYouSureDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _api.deleteProduct(product.id, accountId: selectedAccount!.id);
                Navigator.pop(context);
                _showSuccessSnackBar(
                    AppLocalizations.of(context).productDeletedSuccessfully);

                final updatedList = List<ProductRegistrationData>.from(_productsNotifier.value);
                updatedList.removeAt(index);
                _productsNotifier.value = updatedList;

              } catch (e) {
                _showErrorSnackBar('Erro ao excluir produto: $e');
              }
            },
            child: Text(
              AppLocalizations.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppDrawer(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).productList),
                automaticallyImplyLeading: false,
                actions: [
                  DropdownButton<Locale>(
                    icon: const Icon(Icons.language, color: Colors.white),
                    underline: const SizedBox.shrink(),
                    dropdownColor: Colors.black,
                    onChanged: (Locale? locale) {
                      if (locale != null) widget.changeLanguage(locale);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: Locale('pt'),
                        child: Text('Português',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  ThemeToggleButton(),
                ],
              ),
              body: ValueListenableBuilder<List<ProductRegistrationData>>(
                valueListenable: _productsNotifier,
                builder: (context, products, child) {
                  return ATable<ProductRegistrationData>(
                    key: _tableKey,
                    columns: [
                      ATableColumn(
                        title: AppLocalizations.of(context).name,
                        cellBuilder: (_, __, item) => Text(item.name),
                      ),
                      ATableColumn(
                        title: AppLocalizations.of(context).price,
                        cellBuilder: (_, __, item) =>
                            Text("R\$ ${item.value.toStringAsFixed(2)}"),
                      ),
                      ATableColumn(
                        title: AppLocalizations.of(context).image,
                        cellBuilder: (_, __, item) => item.url != null
                            ? Image.network(item.url!,
                            width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 50),
                      ),
                      ATableColumn(
                        cellBuilder: (_, __, item) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: AppLocalizations.of(context).edit,
                                onPressed: () => _editProduct(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: AppLocalizations.of(context).delete,
                                onPressed: () {
                                  final index = _productsNotifier.value.indexOf(item);
                                  if (index != -1) {
                                    _confirmDelete(index);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    loadItems: (_, __) async {
                      return _productsNotifier.value;
                    },
                    emptyMessage: AppLocalizations.of(context).noProducts,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}