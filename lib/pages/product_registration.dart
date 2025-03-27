import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_field_url.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/pages/profile_page.dart';

class ProductRegistrationPage extends StatefulWidget {
  final String username;
  final void Function(Locale) changeLanguage;

  ProductRegistrationPage({super.key, required this.username, required this.changeLanguage});

  @override
  _ProductRegistrationPageState createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productImageController = TextEditingController();
  final MoneyMaskedTextController productPriceController = Configs.productPriceFormatter;

  List<Map<String, String>> products = [];
  int _selectedIndex = 0;

  void _showProductDialog({int? editingIndex}) {
    if (editingIndex != null) {
      productNameController.text = products[editingIndex]['name']!;
      productImageController.text = products[editingIndex]['image']!;
      productPriceController.text = products[editingIndex]['price']!;
    } else {
      productNameController.clear();
      productImageController.clear();
      productPriceController.updateValue(0.0);
    }

    Future<void> showProductDialog(BuildContext context, {Map<String, dynamic>? product}) async {
      await AFormDialog.show<Map<String, dynamic>>(
        context,
        title: editingIndex != null
            ? AppLocalizations.of(context).editProduct
            : AppLocalizations.of(context).registerProduct,
        submitText: editingIndex != null
            ? AppLocalizations.of(context).edit
            : AppLocalizations.of(context).register,
        onSubmit: (dynamic data) async {
          setState(() {
            if (editingIndex != null) {
              products[editingIndex] = {
                'name': data['product_name'],
                'image': data['product_image_url'],
                'price': data['product_price'],
              };
            } else {
              products.add({
                'name': data['product_name'],
                'image': data['product_image_url'],
                'price': data['product_price'],
              });
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(editingIndex != null
                  ? AppLocalizations.of(context).productUpdatedSuccessfully
                  : AppLocalizations.of(context).productRegisteredSuccessfully),
              backgroundColor: DefaultColors.green,
              duration: Duration(seconds: 2),
            ),
          );
          return null;
        },
        fields: [
          AFieldText(
            identifier: 'product_name',
            label: AppLocalizations.of(context).productName,
            required: true,
            initialValue: productNameController.text,
          ),
          const SizedBox(height: 16),
          AFieldMoney(
            identifier: 'product_price',
            label: AppLocalizations.of(context).productPrice,
            required: true,
            initialValue: productPriceController.text,
          ),
          const SizedBox(height: 16),
          AFieldURL(
            identifier: 'product_image_url',
            label: AppLocalizations.of(context).productImageURL,
            required: true,
            initialValue: productImageController.text,
          ),
        ],
        persistent: false,
        fromJson: (json) => json as Map<String, dynamic>,
      );
    }

    showProductDialog(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                  products.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    print(products);
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
          AppLocalizations.of(context).pressButtonToAddProduct,
          style: TextStyle(fontSize: 16),
        ),
      )
          : _selectedIndex == 1
          ? products.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context).noProducts,
            style: TextStyle(fontSize: 20)
        ),
      )
          : ShowProductPage(
        products: products,
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
            icon: Icon(Icons.add),
            label: AppLocalizations.of(context).register,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: AppLocalizations.of(context).products,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: AppLocalizations.of(context).profile,
          ),
        ],
      ),
    );
  }
}
