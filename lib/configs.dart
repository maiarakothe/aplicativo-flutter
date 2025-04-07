import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/account.dart';

  Account? selectedAccount;
class Configs {

  // BorderRadius
  static BorderRadius radiusBorder = BorderRadius.circular(16);

  // BorderRadius para botão
  static BorderRadius buttonBorderRadius = BorderRadius.circular(28);

  // Máscara para valores de produto
  static final productPriceFormatter = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: "R\$ ",
    initialValue: 0,
    precision: 2,
  );

  // Máscara para URL da imagem
  static List<String> imageURLMask = ['http://*', 'https://*'];

  // Formatador para URL
  static final urlFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]"),
  );
}
