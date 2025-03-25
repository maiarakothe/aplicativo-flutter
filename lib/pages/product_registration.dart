import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/utils/validators.dart';
import 'package:teste/services/auth_service.dart';

class ProductRegistrationPage extends StatefulWidget {
  final String username;
  final void Function(Locale) changeLanguage;

  ProductRegistrationPage({super.key, required this.username, required this.changeLanguage});

  @override
  _ProductRegistrationPageState createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productImageController = TextEditingController();
  final MoneyMaskedTextController productPriceController = Configs.productPriceFormatter;
  final List<Map<String, String>> produtos = [];

  int? _editingIndex;
  int _selectedIndex = 0;

  final AuthService _authService = AuthService();

  void _showProductDialog({int? editingIndex}) {
    if (editingIndex != null) {
      productNameController.text = produtos[editingIndex]['nome']!;
      productImageController.text = produtos[editingIndex]['imagem']!;
      productPriceController.text = produtos[editingIndex]['preco']!;
    } else {
      _formKey.currentState?.reset();
      productNameController.clear();
      productImageController.clear();
      productPriceController.updateValue(0.0);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            editingIndex != null
                ? AppLocalizations.of(context).editProduct
                : AppLocalizations.of(context).registerProduct,
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800,
              maxHeight: 400,
              minWidth: 300,
              minHeight: 200,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).productName,
                      border: OutlineInputBorder(
                        borderRadius: Configs.radiusBorder,
                      ),
                    ),
                    validator: (value) => Validators.validateProductName(value, AppLocalizations.of(context)),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: productPriceController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).productPrice,
                      border: OutlineInputBorder(
                        borderRadius: Configs.radiusBorder,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => Validators.validateProductPrice(value, AppLocalizations.of(context)),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: productImageController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).productImageURL,
                      border: OutlineInputBorder(
                        borderRadius: Configs.radiusBorder,
                      ),
                    ),
                    keyboardType: TextInputType.url,
                    inputFormatters: [Configs.urlFormatter],
                    validator: (value) => Validators.validateProductImageURL(value, AppLocalizations.of(context)),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (editingIndex != null) {
                    produtos[editingIndex] = {
                      'nome': productNameController.text,
                      'imagem': productImageController.text,
                      'preco': productPriceController.text,
                    };
                  } else {
                    produtos.add({
                      'nome': productNameController.text,
                      'imagem': productImageController.text,
                      'preco': productPriceController.text,
                    });
                  }
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(editingIndex != null
                        ? AppLocalizations.of(context).productUpdatedSuccessfully
                        : AppLocalizations.of(context).productRegisteredSuccessfully),
                    backgroundColor: DefaultColors.snackBar,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context).save),
          ),
        ],
      ),
    );
  }

  void _editProduct(int index) {
    _showProductDialog(editingIndex: index);
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: 400,
          minWidth: 400,
          minHeight: 200,
        ),
        child: AlertDialog(
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
                  produtos.removeAt(index);
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
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context).hello}, ${widget.username}!"),
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
          Tooltip(
            message: AppLocalizations.of(context).logout,
            child: IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Center(
        child: Text(
          AppLocalizations.of(context).pressButtonToAddProduct,
          style: TextStyle(fontSize: 16),
        ),
      )
          : ShowProductPage(
        produtos: produtos,
        onEdit: _editProduct,
        onDelete: _confirmDelete,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showProductDialog,
        backgroundColor: DefaultColors.backgroundButton,
        child: Icon(Icons.add, color: DefaultColors.textColorButton),
      ),
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
        ],
      ),
    );
  }
}
