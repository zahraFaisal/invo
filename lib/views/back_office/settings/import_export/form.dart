import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:invo_mobile/models/custom/export_database.dart';
import 'package:invo_mobile/models/custom/import_database.dart';
import 'package:invo_mobile/blocs/back_office/settings/import_export_form/import_export_form_bloc.dart';
import 'dart:convert';
import 'dart:io';

class ImportExportForm extends StatefulWidget {
  ImportExportForm({Key? key}) : super(key: key);

  @override
  State<ImportExportForm> createState() => _ImportExportFormState();
}

class _ImportExportFormState extends State<ImportExportForm> {
  bool menuIsSwitched = false;
  bool dineInIsSwitched = false;
  bool customerIsSwitched = false;
  bool employeeIsSwitched = false;
  bool surchargeIsSwitched = false;
  bool discountIsSwitched = false;
  bool paymentIsSwitched = false;

  late ImportExportBloc importExportBloc;

  void initState() {
    super.initState();
    importExportBloc = new ImportExportBloc();
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    File file;
    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      return;
    }

    if (file != null) {
      try {
        final contents = json.decode(await file.readAsString());
        ExportDatabase exportDatabase = ExportDatabase.fromMap(contents);
        ImportDatabase importDatabase = new ImportDatabase(exportDatabase: exportDatabase);
        importExportBloc.importData(importDatabase.exportDatabase!);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void exportData() {
    importExportBloc.exportData(
        menuIsSwitched, dineInIsSwitched, customerIsSwitched, employeeIsSwitched, surchargeIsSwitched, discountIsSwitched, paymentIsSwitched);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey[100],
              child: Center(
                child: Text(
                  "Import/Export",
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: menuIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      menuIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DineIn Table',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: dineInIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      dineInIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customers',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: customerIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      customerIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Employee',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: employeeIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      employeeIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Surcharge',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: surchargeIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      surchargeIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: discountIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      discountIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Methods',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: paymentIsSwitched,
                  onChanged: (value) {
                    setState(() {
                      paymentIsSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonTheme(
                  height: 70,
                  minWidth: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                    child: Text(
                      'Import Database',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    onPressed: () {
                      _pickFile();
                    },
                  ),
                ),
                SizedBox(width: 15),
                ButtonTheme(
                  height: 70,
                  minWidth: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                    child: Text(
                      'Export Database',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    onPressed: () {
                      exportData();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
