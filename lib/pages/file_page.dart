import 'dart:convert';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../api/api.dart';
import '../api/api_product.dart';
import '../configs.dart';
import '../core/colors.dart';
import '../core/responsive_scaffold.dart';
import '../theme_toggle_button.dart';

class FilePage extends StatefulWidget {
  final void Function(Locale) changeLanguage;
  const FilePage({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  List<Map<String, dynamic>> validatedProducts = [];

  Future<void> _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );

    if (result == null) return;

    PlatformFile file = result.files.first;
    final extension = file.extension ?? '';
    validatedProducts.clear();

    if (extension == 'xlsx') {
      final excel = ex.Excel.decodeBytes(file.bytes!);
      for (var table in excel.tables.keys) {
        final rows = excel.tables[table]!.rows
            .map((row) => row.map((cell) => cell?.value ?? "").toList())
            .toList();

        if (rows.isEmpty) continue;

        final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
        final nameIndex = headers.indexOf('nome');
        final priceIndex = headers.indexOf('preço');
        final urlIndex = headers.indexOf('url');

        if (nameIndex == -1 || priceIndex == -1 || urlIndex == -1) continue;

        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length <= urlIndex) continue;

          final name = row[nameIndex]?.toString().trim();
          final price = double.tryParse(row[priceIndex]?.toString() ?? '');
          final url = row[urlIndex]?.toString().trim();

          if (name != null && name.isNotEmpty && price != null && url != null && url.isNotEmpty) {
            validatedProducts.add({'name': name, 'value': price, 'url': url});
          }
        }
      }
    } else if (extension == 'csv') {
      final csvString = utf8.decode(file.bytes!);
      final csvRows = const CsvToListConverter().convert(csvString);

      if (csvRows.isEmpty) return;

      final headers = csvRows[0].map((e) => e.toString().toLowerCase()).toList();
      final nameIndex = headers.indexOf('nome');
      final priceIndex = headers.indexOf('preço');
      final urlIndex = headers.indexOf('url');

      if (nameIndex == -1 || priceIndex == -1 || urlIndex == -1) return;

      for (int i = 1; i < csvRows.length; i++) {
        final row = csvRows[i];
        if (row.length <= urlIndex) continue;

        final name = row[nameIndex]?.toString().trim();
        final price = double.tryParse(row[priceIndex]?.toString() ?? '');
        final url = row[urlIndex]?.toString().trim();

        if (name != null && name.isNotEmpty && price != null && url != null && url.isNotEmpty) {
          validatedProducts.add({'name': name, 'value': price, 'url': url});
        }
      }
    }

    if (validatedProducts.isEmpty) {
      _showNoValidProductsDialog();
      return;
    }

    _showConfirmationDialog();
  }

  Future<void> _uploadProducts() async {
    final api = ProductAPI(API());
    int success = 0;

    for (var product in validatedProducts) {
      try {
        await api.createProduct(
          name: product['name'],
          value: product['value'],
          url: product['url'],
          accountId: selectedAccount!.id,
        );
        success++;
      } catch (e) {
        debugPrint("Erro ao importar: $e");
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(AppLocalizations.of(context).importCompleteSuccess(success)),
          backgroundColor: Colors.green
      ),
    );

    setState(() {});
  }

  void _showNoValidProductsDialog() {
    ADialogV2.show<void>(
      context: context,
      title: AppLocalizations.of(context).noValidProductsTitle,
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Text(AppLocalizations.of(context).noValidProductsContent),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: AButton(
              text: AppLocalizations.of(context).ok,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    ADialogV2.show<bool>(
      context: context,
      title: AppLocalizations.of(context).confirmUploadTitle,
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(AppLocalizations.of(context).foundProducts(validatedProducts.length)),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text(AppLocalizations.of(context).name)),
                DataColumn(label: Text(AppLocalizations.of(context).price)),
                DataColumn(label: Text(AppLocalizations.of(context).image)),
              ],
              rows: validatedProducts.map((product) {
                return DataRow(cells: [
                  DataCell(Text(product['name'])),
                  DataCell(Text(product['value'].toStringAsFixed(2))),
                  DataCell(Image.network(product['url'], height: 40)),
                ]);
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AButton(
                text: AppLocalizations
                    .of(context)
                    .cancel,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(width: 10),
              AButton(
                text: AppLocalizations.of(context).confirm,
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _uploadProducts();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).importFile),
        automaticallyImplyLeading: false,
        actions: [
          DropdownButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            underline: const SizedBox.shrink(),
            dropdownColor: Colors.black,
            onChanged: (Locale? locale) {
              if (locale != null) widget.changeLanguage(locale);
            },
            items: const [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AButton(
              text: AppLocalizations.of(context).importFile,
              landingIcon: Icons.upload_file,
              onPressed: _importFile,
              color: DefaultColors.circleAvatar,
              fontWeight: FontWeight.bold,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const Divider(),
          if (validatedProducts.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).importedDataMessage,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 70.0,
                              columns: [
                                DataColumn(label: Text(AppLocalizations.of(context).name)),
                                DataColumn(label: Text(AppLocalizations.of(context).price)),
                                DataColumn(label: Text(AppLocalizations.of(context).image)),
                              ],
                              rows: validatedProducts.map((product) {
                                return DataRow(cells: [
                                  DataCell(Text(product['name'])),
                                  DataCell(Text(product['value'].toStringAsFixed(2))),
                                  DataCell(Image.network(product['url'], height: 40)),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
