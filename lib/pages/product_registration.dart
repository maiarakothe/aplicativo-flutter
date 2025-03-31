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

class ProductRegistrationPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;
  final ValueNotifier<List<ProductRegistrationData>> productsNotifier = ValueNotifier([]);

  ProductRegistrationPage({super.key, required this.changeLanguage});

  @override
  _ProductRegistrationPageState createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  int _selectedIndex = 0;

  void _showProductDialog({int? editingIndex}) async {
    ProductRegistrationData? initialProduct;

    if (editingIndex != null) {
      initialProduct = widget.productsNotifier.value[editingIndex];
    }

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

          final priceText = data['product_price'] as String;
          final priceWithoutThousandSeparator = priceText.replaceAll('.', '');
          final priceWithDecimalPoint = priceWithoutThousandSeparator.replaceAll(',', '.');
          final price = double.tryParse(priceWithDecimalPoint) ?? 0.0;

          final newProduct = ProductRegistrationData(
            productName: data['productName'] as String,
            url: data['url'] as String,
            price: price,
          );

          setState(() {
            if (editingIndex != null) {
              widget.productsNotifier.value[editingIndex] = newProduct;
            } else {
              widget.productsNotifier.value.add(newProduct);
            }
            widget.productsNotifier.value = List.from(widget.productsNotifier.value);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(editingIndex != null
                  ? AppLocalizations.of(context)!.productUpdatedSuccessfully
                  : AppLocalizations.of(context)!.productRegisteredSuccessfully),
              backgroundColor: DefaultColors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          return null;
        },
      fields: [
        AFieldText(
          identifier: 'productName',
          label: AppLocalizations.of(context)!.productName,
          required: true,
          initialValue: initialProduct?.productName ?? '',
        ),
        const SizedBox(height: 16),
        AFieldMoney(
          identifier: 'product_price',
          label: AppLocalizations.of(context)!.productPrice,
          required: true,
          initialValue: initialProduct?.price.toStringAsFixed(2),
          customRules: [
                (value) {
              final parsed = double.tryParse(
                value?.replaceAll('.', '').replaceAll(',', '.') ?? '',
              );
              if (parsed == null || parsed <= 0.0) {
                return AppLocalizations.of(context)!.insertProductPrice;
              }
              return null;
            }
          ],
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
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.productsNotifier.value.removeAt(index);
                  widget.productsNotifier.value = List.from(widget.productsNotifier.value);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).productDeletedSuccessfully),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
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
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: Locale('pt'),
                child: Text('Português', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          ThemeToggleButton(),
        ],
      ),
      body: _selectedIndex == 0
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.pressButtonToAddProduct,
          style: const TextStyle(fontSize: 16),
        ),
      )
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