import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowProductPage extends StatelessWidget {
  final List<Map<String, String>> produtos;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  ShowProductPage({required this.produtos, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: produtos.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context).noProducts,
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(produtos[index]['imagem']!),
            title: Text(produtos[index]['nome']!),
            subtitle: Text('${AppLocalizations.of(context).price}: R\$ ${produtos[index]['preco']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: AppLocalizations.of(context).edit,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => onEdit(index),
                  ),
                ),
                Tooltip(
                  message: AppLocalizations.of(context).delete,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}