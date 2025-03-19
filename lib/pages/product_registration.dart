import 'package:flutter/material.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:teste/core/theme_provider.dart';

class ProductRegistrationPage extends StatefulWidget {
  final String username;

  ProductRegistrationPage({super.key, required this.username});

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

  void _registerProduct() {
    if (_formKey.currentState?.validate() ?? false) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(

        title: Text(
          "Olá, ${widget.username}!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [ThemeToggleButton()],
      ),


      body: _selectedIndex == 0
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Registre o seu produto:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: "Nome do Produto",
                    border: OutlineInputBorder(
                      borderRadius: Configs.radiusBorder,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do produto';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: productPriceController,
                  decoration: InputDecoration(
                    labelText: "Valor do Produto",
                    border: OutlineInputBorder(
                      borderRadius: Configs.radiusBorder,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [Configs.productPriceFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor do produto';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: productImageController,
                  decoration: InputDecoration(
                    labelText: "Imagem do Produto (URL)",
                    border: OutlineInputBorder(
                      borderRadius: Configs.radiusBorder,
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  inputFormatters: [Configs.urlFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a URL da imagem';
                    }
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return 'A URL deve começar com http:// ou https://';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _registerProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DefaultColors.backgroundButton,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: Configs.buttonBorderRadius,
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Cadastrar Produto",
                    style: TextStyle(fontSize: 18, color: DefaultColors.textColorButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : ShowProductPage(produtos: produtos),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Registrar'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Produtos'),
        ],
      ),
    );
  }
}
