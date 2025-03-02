import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _registerProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      print("Produto cadastrado com sucesso");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B5E3B),
        title: Text(
          "Olá, ${widget.username}!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
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
                    color: Color(0xFF8B5E3B),
                  ),
                ),
                SizedBox(height: 40),

                // Campo de Nome do Produto
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: "Nome do Produto",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do produto';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),  // Consistent spacing

                // Campo do Valor do Produto
                TextFormField(
                  controller: productPriceController,
                  decoration: InputDecoration(
                    labelText: "Valor do Produto",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor do produto';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),  // Consistent spacing

                // Campo da Imagem do Produto
                TextFormField(
                  controller: productImageController,
                  decoration: InputDecoration(
                    labelText: "Imagem do Produto (URL)",
                    hintText: 'http://www.site.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a URL da imagem';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),  // Consistent spacing

                // Botão de Cadastro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B5E3B),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _registerProduct,
                  child: Text(
                    "Cadastrar Produto",
                    style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
