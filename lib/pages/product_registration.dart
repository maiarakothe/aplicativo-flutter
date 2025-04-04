import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_field_url.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/pages/profile_page.dart';
import '../models/product_registration.dart';
import '../api/api.dart';
import 'package:dio/dio.dart';
import '../api/api_product.dart';

class ProductRegistrationPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;
  final ProductAPI _productAPI = ProductAPI(API());
  final ValueNotifier<List<ProductRegistrationData>> productsNotifier = ValueNotifier([]);

  ProductRegistrationPage({super.key, required this.changeLanguage});

  @override
  _ProductRegistrationPageState createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await widget._productAPI.getAllProducts();
      print('Produtos carregados: $products');
      widget.productsNotifier.value = products.map((p) => ProductRegistrationData.fromJson(p)).toList();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  void _showProductDialog({int? editingIndex}) async {
    ProductRegistrationData? initialProduct = editingIndex != null ? widget.productsNotifier.value[editingIndex] : null;

    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: editingIndex != null
          ? AppLocalizations.of(context)!.editProduct
          : AppLocalizations.of(context)!.registerProduct,
      submitText: editingIndex != null
          ? AppLocalizations.of(context)!.edit
          : AppLocalizations.of(context)!.register,
      fromJson: (json) => json as Map<String, dynamic>,
      initialData: initialProduct?.toJson(),
      onSubmit: (data) async {
        try {
          print("Dados recebidos no formulário:");
          print(data);

          final price = double.tryParse(data['product_price']
              .replaceAll('.', '')
              .replaceAll(',', '.')) ?? 0.0;

          final newProduct = ProductRegistrationData(
            id: initialProduct?.id ?? 0,
            name: data['productName'],
            url: data['url'],
            value: price,
          );

          if (editingIndex != null) {
            await widget._productAPI.updateProduct(
              id: newProduct.id ?? 0,
              name: newProduct.name,
              value: newProduct.value,
              url: newProduct.url,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.productUpdatedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            await widget._productAPI.createProduct(
              name: newProduct.name,
              value: newProduct.value,
              url: newProduct.url,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.productRegisteredSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }

          print("Produto salvo com sucesso!");
          _loadProducts();
        } catch (e) {
          print('Erro ao salvar produto: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar produto: $e'), backgroundColor: Colors.red),
          );
        }
      },
      fields: [
        AFieldText(
          identifier: 'productName',
          label: AppLocalizations.of(context)!.productName,
          required: true,
          initialValue: initialProduct?.name ?? '',
        ),
        const SizedBox(height: 16),
        AFieldMoney(
          identifier: 'product_price',
          label: AppLocalizations.of(context)!.productPrice,
          required: true,
          initialValue: initialProduct?.value.toStringAsFixed(2) ?? '',
        ),
        const SizedBox(height: 16),
        AFieldURL(
          identifier: 'url',
          label: AppLocalizations.of(context)!.productImageURL,
          required: true,
          initialValue: initialProduct?.url ?? '',
        ),
      ],
    );
  }

  void _editProduct(int index) {
    _showProductDialog(editingIndex: index);
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppLocalizations.of(context).confirmDelete,
              textAlign: TextAlign.center,
            ),
          ),
          content: Text(AppLocalizations.of(context).areYouSureDelete),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context).cancel)
            ),
            TextButton(
              onPressed: () async {
                try {
                  await widget._productAPI.deleteProduct(
                      widget.productsNotifier.value[index].id
                  );
                  _loadProducts();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.productDeletedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('Erro ao excluir produto: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir produto: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).delete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          DropdownButton<Locale>(
            icon: Icon(Icons.language, color: Colors.white),
            underline: SizedBox.shrink(),
            dropdownColor: Colors.black,
            onChanged: (Locale? newValue) {
              if (newValue != null) {
                widget.changeLanguage(newValue);
              }
            },
            items: [
              DropdownMenuItem(value: Locale('en'), child: Text('English', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: Locale('pt'), child: Text('Português', style: TextStyle(color: Colors.white))),
            ],
          ),
          ThemeToggleButton(),
        ],
      ),
      body: _selectedIndex == 0
          ? Center(child: Text(AppLocalizations.of(context)!.pressButtonToAddProduct, style: const TextStyle(fontSize: 16)))
          : _selectedIndex == 1
          ? ShowProductPage(
            productsNotifier: widget.productsNotifier,
            onEdit: _editProduct,
            onDelete: _confirmDelete,
      )
          : ProfilePage(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () => _showProductDialog(),
        backgroundColor: DefaultColors.backgroundButton,
        child: Icon(Icons.add, color: DefaultColors.textColorButton),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.add),
            label: AppLocalizations.of(context)!.register,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context)!.products,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}