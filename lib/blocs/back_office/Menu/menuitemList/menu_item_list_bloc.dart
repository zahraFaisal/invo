import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuitemList/menu_item_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;

import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/widgets/order_notification.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class MenuItemListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<MenuItemListEvent>.broadcast();
  Sink<MenuItemListEvent> get eventSink => _eventController.sink;
  Property<List<MenuItemList>> list = new Property<List<MenuItemList>>();
  var allItems = List<MenuItemList>.empty(growable: true);
  bool _isDisposed = false;
  NavigatorBloc? _navigationBloc;
  MenuItemListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void loadList(List<int>? except) async {
    allItems = (await connectionRepository!.menuItemService!.getActiveList(except: except))!;
    if (_isDisposed == false) list.sinkValue(allItems);
  }

  void deleteMenuItem(int id) async {
    connectionRepository!.menuItemService!.delete(id);
    loadList(null);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allItems);
    } else {
      list.sinkValue(allItems.where((f) => f.name.toLowerCase().contains(query.toLowerCase()) || f.barcode.contains(query)).toList());
    }
  }

  void _mapEventToState(MenuItemListEvent event) {
    if (event is LoadMenuItem) {
      loadList(null);
    } else if (event is DeleteMenuItem) {
      deleteMenuItem(event.item.id);
    } else if (event is ImportMenuItem) {
      if (event.isImport == "Import") {
        importMenuItems();
      } else if (event.isImport == "download") {
        print("download");
        downloadTemplate();
      }
    }
  }

  downloadTemplate() async {
    String path = "/download/MenuItemTemplate.csv";
    Directory directory;
    if (await _requestPermission(Permission.storage)) {
      directory = (await getExternalStorageDirectory())!;
      String newPath = "";
      print(directory);
      List<String> paths = directory.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/download/MenuItemTemplate.csv";
      directory = Directory(newPath);
      var data = await rootBundle.load("assets/MenuItemTemplate.csv");
      var list = data.buffer.asUint8List();
      await new File(newPath).writeAsBytes(list);
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  importMenuItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    File file;
    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      return;
    }

    String lang = locator.get<ConnectionRepository>().terminal!.getLangauge()!;
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang));

    if (file != null) {
      final input = file.openRead();
      final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
      locator.get<DialogService>().showLoadingProgressDialog();
      var category = await connectionRepository!.menuCategoryService!.getList();

      for (var item in fields) {
        print(item);
        if (item[0] != "Barcode") {
          mi.MenuItem menuItem = mi.MenuItem();
          menuItem.barcode = item[0].toString();
          if (await connectionRepository!.menuItemService!.checkIfBarcodeExists(menuItem)) {
            showToast(appLocalizations.translate("Cannot Add Two Similar Barcode Values"), duration: Duration(seconds: 3), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: 0));
          }
          menuItem.name = item[1].toString();
          if (await connectionRepository!.menuItemService!.checkIfNameExists(menuItem)) {
            showToast(appLocalizations.translate("Cannot Add Two Similar Name Values"), duration: Duration(seconds: 3), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: 0));
          }
          var tempCat = null;
          if (category!.length > 0) tempCat = category.firstWhere((element) => element.name.toLowerCase().trim() == item[2].toLowerCase().trim(), orElse: null);

          menuItem.menu_category_id = tempCat != null ? tempCat.id : null;
          menuItem.countDown = item[3] == "" ? 0 : int.parse(item[3].toString());
          menuItem.default_price = double.parse(item[4].toString());
          menuItem.description = item[5];
          menuItem.additional_cost = 0.0;
          await connectionRepository!.menuItemService!.save(menuItem);
        }
      }
      loadList(null);
      locator.get<DialogService>().closeDialog();
    } else {
      // User canceled the picker
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    list.dispose();
  }
}
