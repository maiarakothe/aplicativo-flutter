import 'package:flutter/material.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';

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

  void _showProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cadastrar Produto"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
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
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, ${widget.username}!"),
        actions: [ThemeToggleButton()],
      ),
      body: _selectedIndex == 0
          ? Center(
        child: Text(
          "Pressione o botão para adicionar um produto",
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Registrar'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Produtos'),
        ],
      ),
    );
  }
}
