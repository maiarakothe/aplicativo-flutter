import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_field_url.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import '../api/api.dart';
import '../configs.dart';
import '../core/app_drawer.dart';
import '../models/product_registration.dart';
import '../api/api_product.dart';
import '../theme_toggle_button.dart';

class ProductRegistrationPage extends StatefulWidget {
  final void Function(Locale locale) changeLanguage;

  const ProductRegistrationPage({super.key, required this.changeLanguage});

  @override
  State<ProductRegistrationPage> createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final ProductAPI _api = ProductAPI(API());
  final ValueNotifier<List<ProductRegistrationData>> _productsNotifier = ValueNotifier([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args['productId'] != null) {
      final productId = args['productId'];
      if (productId is int) {
        _openProductForEditing(productId);
      } else if (productId is String) {
        _openProductForEditing(int.tryParse(productId) ?? -1);
      }
    } else {
      _loadProducts();
    }
  }


  Future<void> _loadProducts() async {
    try {
      final products = await _api.getAllProducts(accountId: selectedAccount!.id);
      _productsNotifier.value = products.map((p) => ProductRegistrationData.fromJson(p)).toList();
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      String errorMessage = "Erro ao tentar carregar produtos.";
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage = "Não autorizado.";
        } else if (e.response?.statusCode == 422) {
          errorMessage = "Erro de validação.";
        }
      }
    }
  }

  Future<void> _openProductForEditing(int id) async {
    try {
      final json = await _api.getProductById(id);
      final product = ProductRegistrationData.fromJson(json);

      await _loadProducts();

      final index = _productsNotifier.value.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _showProductForm(editingIndex: index);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro"), backgroundColor: Colors.red),
      );
    }
  }

  void _showProductForm({int? editingIndex}) async {
    ProductRegistrationData? initial = editingIndex != null ? _productsNotifier.value[editingIndex] : null;

    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: editingIndex != null
          ? AppLocalizations.of(context)!.editProduct
          : AppLocalizations.of(context)!.registerProduct,
      submitText: editingIndex != null
          ? AppLocalizations.of(context)!.edit
          : AppLocalizations.of(context)!.register,
      fromJson: (json) => json as Map<String, dynamic>,
      initialData: initial?.toJson(),
      onSubmit: (data) async {
        final price = double.tryParse(
            data['product_price'].replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;

        final product = ProductRegistrationData(
          id: initial?.id ?? 0,
          name: data['productName'],
          url: data['url'],
          value: price,
        );

        try {
          if (editingIndex != null) {
            await _api.updateProduct(
              id: product.id!,
              name: product.name,
              value: product.value,
              url: product.url,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.productUpdatedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            await _api.createProduct(
              name: product.name,
              value: product.value,
              url: product.url,
              accountId: selectedAccount!.id,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.productRegisteredSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }
          _loadProducts();
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao salvar produto"), backgroundColor: Colors.red),
          );
        }
      },
      fields: [
        AFieldText(
          identifier: 'productName',
          label: AppLocalizations.of(context)!.productName,
          required: true,
          initialValue: initial?.name ?? '',
        ),
        const SizedBox(height: 16),
        AFieldMoney(
          identifier: 'product_price',
          label: AppLocalizations.of(context)!.productPrice,
          required: true,
          initialValue: initial?.value.toStringAsFixed(2) ?? '',
        ),
        const SizedBox(height: 16),
        AFieldURL(
          identifier: 'url',
          label: AppLocalizations.of(context)!.productImageURL,
          required: true,
          initialValue: initial?.url ?? '',
        ),
      ],
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
                title: Text(AppLocalizations.of(context)!.registerProduct),
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
                      DropdownMenuItem(value: Locale('en'), child: Text('English', style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(value: Locale('pt'), child: Text('Português', style: TextStyle(color: Colors.white))),
                    ],
                  ),
                  ThemeToggleButton(),
                ],
              ),
              body: const Center(
                child: Text('Clique no botão para cadastrar um produto'),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => _showProductForm(),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.registerProduct),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
