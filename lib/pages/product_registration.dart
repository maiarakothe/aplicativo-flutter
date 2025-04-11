import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_field_url.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import '../api/api.dart';
import '../configs.dart';
import '../core/responsive_scaffold.dart';
import '../models/product_registration.dart';
import '../api/api_product.dart';
import '../theme_toggle_button.dart';

class ProductRegistrationPage extends StatefulWidget {
  final void Function(Locale locale) changeLanguage;
  final int? productId;

  const ProductRegistrationPage({super.key, required this.changeLanguage, this.productId});

  @override
  State<ProductRegistrationPage> createState() =>
      _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final ProductAPI _api = ProductAPI(API());
  ProductRegistrationData? _editingProduct;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProductDetails(widget.productId!);
    } else {
      _showProductForm();
    }
  }

  Future<void> _loadProductDetails(int productId) async {
    try {
      final productData = await _api.getProductById(productId, accountId: selectedAccount!.id);

      _editingProduct = ProductRegistrationData(
        id: widget.productId!,
        name: productData['name'] as String? ?? '',
        category: productData['category_type'] as String?,
        quantity: productData['quantity'] as int?,
        value: (productData['value'] as num?)?.toDouble() ?? 0.0,
        url: productData['url'] as String?,
      );

      _showProductForm(initial: _editingProduct);
    } catch (e) {
      debugPrint('Erro ao carregar detalhes do produto: $e');
      SnackBar(
          content: Text('Erro ao carregar detalhes do produto.',));
    }
  }

  void _showProductForm({ProductRegistrationData? initial}) async {
    debugPrint('Initial product data: $initial');
    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: initial != null
          ? AppLocalizations.of(context).editProduct
          : AppLocalizations.of(context).registerProduct,
      submitText: initial != null
          ? AppLocalizations.of(context).edit
          : AppLocalizations.of(context).register,
      fromJson: (json) => json as Map<String, dynamic>,
      initialData: initial?.toJson(),
      onSubmit: (data) async {
        final price = double.tryParse(data['product_price']
            .replaceAll('.', '')
            .replaceAll(',', '.')) ??
            0.0;

        final product = ProductRegistrationData(
          id: widget.productId ?? 0,
          name: data['productName'],
          url: data['url'],
          value: price,
        );

        try {
          if (widget.productId != null) {
            await _api.updateProduct(
              id: product.id,
              name: product.name,
              value: product.value,
              url: product.url!,
              accountId: selectedAccount!.id,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context).productUpdatedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            await _api.createProduct(
              name: product.name,
              value: product.value,
              url: product.url!,
              accountId: selectedAccount!.id,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).productRegisteredSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }
          Navigator.pop(context);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context).erroProduct),
                backgroundColor: Colors.red),
          );
        }
        return null;
      },
      fields: [
        AFieldText(
          identifier: 'productName',
          label: AppLocalizations.of(context).productName,
          required: true,
          initialValue: initial?.name ?? '',
        ),
        const SizedBox(height: 16),
        AFieldMoney(
          identifier: 'product_price',
          label: AppLocalizations.of(context).productPrice,
          required: true,
          initialValue: initial?.value.toStringAsFixed(2) ?? '',
        ),
        const SizedBox(height: 16),
        AFieldURL(
          identifier: 'url',
          label: AppLocalizations.of(context).productImageURL,
          required: true,
          initialValue: initial?.url ?? '',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).registerProduct),
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
                      style: TextStyle(color: Colors.white))),
              DropdownMenuItem(
                  value: Locale('pt'),
                  child: Text('Português',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: Center(
        child: Text(AppLocalizations.of(context).pressButtonToAddProduct),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductForm(),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).registerProduct),
      ),
    );
  }
}