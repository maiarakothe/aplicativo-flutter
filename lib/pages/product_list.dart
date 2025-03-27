import 'package:flutter/material.dart';

class ShowProductPage extends StatelessWidget {
  final List<Map<String, String>> products;
  final Function(int) onEdit;
  final Function(int) onDelete;

  ShowProductPage({required this.products, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            leading: Image.network(
              product['image']!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product['name']!),
            subtitle: Text("Preço: R\$ ${product['price']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => onEdit(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDelete(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
