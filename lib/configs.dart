import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Configs {
  // BorderRadius
  static BorderRadius radiusBorder = BorderRadius.circular(16);

  // BorderRadius para botão
  static BorderRadius buttonBorderRadius = BorderRadius.circular(28);

  // Máscara para valores de produto
  static final productPriceFormatter = FilteringTextInputFormatter.allow(RegExp(r'^\d+([,]\d{0,2})?$'));

  // Formatador para valores de produto
  static String formatPrice(String value) {
    if (value.isEmpty) return '';
      double price = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(price);
    }

  // Máscara para URL da imagem
  static List<String> imageURLMask = ['http://*', 'https://*'];

  // Formatador para URL
  static final urlFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]"),
  );
}
