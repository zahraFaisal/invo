import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:http/http.dart' as http;
import 'package:invo_mobile/blocs/download_template_page/download_template_page_events.dart';
import 'package:path_provider/path_provider.dart';

import '../property.dart';

class Template {
  late String templateName;
  late bool available;
}

class DownloadTemplatePageBloc extends BlocBase {
  final _eventController = StreamController<DownloadTemplatePageEvent>.broadcast();
  Sink<DownloadTemplatePageEvent> get eventSink => _eventController.sink;
  Property<List<dynamic>> templates = Property<List<dynamic>>();
  _getTemplatesname() async {
    if (templates.value == null) {
      final response = await http.get(Uri.https("download.invopos.com", "getReceiptTemplates"));
      var items = [];
      var temp = [];
      for (var item in json.decode(response.body)) {
        debugPrint("item name " + item);
        temp = [];
        temp.add(item);
        temp.add(false);
        items.add(temp);
      }
      final directory = await getApplicationDocumentsDirectory();
      final dir = directory.path;
      String pdfDirectory = '$dir/receiptTemplate';
      final myDir = new Directory(pdfDirectory);
      if ((await myDir.exists())) {
        // TODO:
        print("exist");
      } else {
        // TODO:
        print("not exist");
        myDir.create();
      }

      var _folders = myDir.listSync(recursive: true, followLinks: false);
      List<String> newString = [];
      for (var item in _folders) {
        var temp = item.path.split("/");
        var tempName = temp[temp.length - 1].substring(0, temp[temp.length - 1].length - 5);
        newString.add(tempName.replaceAll("_", " "));
      }

      for (var fileName in newString) {
        for (var i = 0; i < items.length; i++) {
          if (items[i][0] == fileName) {
            items[i][1] = true;
          }
        }
      }

      templates.sinkValue(items);
      debugPrint(templates.value![0][0]);
    }
  }

  DownloadTemplatePageBloc() {
    _getTemplatesname();
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DownloadTemplatePageEvent event) async {
    await _getTemplatesname();
  }

  download(name) async {
    final response = await http.get(Uri.parse('https://download.invopos.com/getReceiptTemplate/$name'));
    print("Creating file!");
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final path = Directory("$appDocPath/receiptTemplate");
    if ((await path.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      path.create();
    }

    var _name = name.replaceAll(' ', '_');
    File file = File('$appDocPath/receiptTemplate/${_name}.json');

    await file.create();
    if ((await file.exists())) {
      // TODO:
      debugPrint(file.path);
      print("file exist");
    } else {
      // TODO:
      print("file not exist");
    }
    file.createSync();
    file.writeAsStringSync(response.body);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
