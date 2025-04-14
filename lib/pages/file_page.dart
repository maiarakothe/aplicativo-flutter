import 'dart:convert';
import 'package:awidgets/general/a_button.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<List<dynamic>>? fileData;

  Future<void> _importFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        final extension = file.extension;

        List<List<dynamic>> importedData = [];

        if (extension == 'xlsx') {
          final excel = Excel.decodeBytes(file.bytes!);
          for (var table in excel.tables.keys) {
            for (var row in excel.tables[table]!.rows) {
              importedData.add(row.map((cell) => cell?.value).toList());
            }
          }
        } else if (extension == 'csv') {
          final csvString = utf8.decode(file.bytes!);
          importedData = const CsvToListConverter().convert(csvString);
        }

        setState(() {
          fileData = importedData;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.fileReadSuccess)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.noFileSelected)),
        );
      }
    } catch (e) {
      debugPrint("Erro ao importar arquivo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fileImportError)),
      );
    }
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
            child:
              AButton(
                text: AppLocalizations.of(context).importFile,
                landingIcon: Icons.file_upload,
                onPressed: _importFile,
                color: DefaultColors.circleAvatar,
                fontWeight: FontWeight.bold,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
          ),
          const Divider(),
          Expanded(
            child: fileData == null
                ? Center(child: Text(AppLocalizations.of(context).noFileImportedYet))
                : ListView.builder(
              itemCount: fileData!.length,
              itemBuilder: (context, index) {
                final row = fileData![index];
                return ListTile(
                  title: Text(row.join(" | ")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
