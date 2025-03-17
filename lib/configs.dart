import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Configs {
  // BorderRadius
  static BorderRadius radiusBorder = BorderRadius.circular(16);

  // BorderRadius para botão
  static BorderRadius buttonBorderRadius = BorderRadius.circular(28);

  // Máscara para valores de produto
  static List<String> productPriceMask = ['R\$ ###,##'];

  // Formatador para valores de produto
  static final productPriceFormatter = MaskTextInputFormatter(
    mask: productPriceMask[0],
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Máscara para URL da imagem
  static List<String> imageURLMask = ['http://*', 'https://*'];

  // Formatador para URL
  static final urlFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]"),
  );
}
