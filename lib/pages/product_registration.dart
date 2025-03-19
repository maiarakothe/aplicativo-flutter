import 'package:flutter/material.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 

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
  final TextEditingController productPriceController = TextEditingController();
  final List<Map<String, String>> produtos = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.registerProduct),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.productName,
                    border: OutlineInputBorder(
                      borderRadius: Configs.radiusBorder,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.insertProductName;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: productPriceController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.productPrice,
                    border: OutlineInputBorder(
                      borderRadius: Configs.radiusBorder,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [Configs.productPriceFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.insertProductPrice;
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    setState(() {
                      productPriceController.text = Configs.formatPrice(productPriceController.text);
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: productImageController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.productImageURL,
                    border: OutlineInputBorder(
                      borderRadius: Configs.radiusBorder,
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  inputFormatters: [Configs.urlFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.insertProductImageURL;
                    }
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return AppLocalizations.of(context)!.urlMustStartWithHTTP;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  produtos.add({
                    'nome': productNameController.text,
                    'imagem': productImageController.text,
                    'preco': productPriceController.text,
                  });
                  productNameController.clear();
                  productImageController.clear();
                  productPriceController.clear();
                });
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.hello}, ${widget.username}!"),
        actions: [
          // Botão para mudar o idioma
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
          style: TextStyle(fontSize: 16),
        ),
      )
          : ShowProductPage(produtos: produtos),
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
            label: AppLocalizations.of(context)!.register,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: AppLocalizations.of(context)!.products,
          ),
        ],
      ),
    );
  }
}

