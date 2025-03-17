import 'package:flutter/material.dart';

class ShowProductPage extends StatelessWidget {
  final List<Map<String, String>> produtos;

  ShowProductPage({required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: produtos.isEmpty
          ? Center(
        child: Text(
          'Nenhum produto cadastrado.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(produtos[index]['imagem']!),
            title: Text(produtos[index]['nome']!),
            subtitle: Text('Preço: R\$ ${produtos[index]['preco']}'),
          );
        },
      ),
    );
  }
}
