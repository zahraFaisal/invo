import 'dart:async';
import 'dart:typed_data';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/models/custom/export_database.dart';
import 'package:invo_mobile/models/custom/import_database.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/models/custom/export_database.dart';
import 'package:invo_mobile/models/menu_category.dart';
// import 'package:ext_storage/ext_storage.dart';
import '../../../../service_locator.dart';
import 'import_export_form_event.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/service_locator.dart';
import 'dart:io';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

import 'dart:convert';

class ImportExportBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<ImportExportEvent>.broadcast();
  Sink<ImportExportEvent> get eventSink => _eventController.sink;

  ImportExportBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ImportExportEvent event) async {}

  Future<bool> importData(ExportDatabase exportDatabase) async {
    try {
      if (exportDatabase.menuCategories != null && exportDatabase.menuCategories!.length > 0) {
        await locator.get<ConnectionRepository>().menuCategoryService!.saveIfNotExists(exportDatabase.menuCategories!);
      }

      if (exportDatabase.priceLabels != null && exportDatabase.priceLabels!.length > 0) {
        await locator.get<ConnectionRepository>().priceService!.saveIfNotExists(exportDatabase.priceLabels!);
      }

      if (exportDatabase.menuTypes != null && exportDatabase.menuTypes!.length > 0) {
        await locator.get<ConnectionRepository>().menuTypeService!.saveIfNotExists(exportDatabase.menuTypes!);
      }

      if (exportDatabase.menuGroups != null && exportDatabase.menuGroups!.length > 0) {
        locator.get<ConnectionRepository>().menuGroupService!.saveIfNotExists(exportDatabase.menuGroups!);
      }

      if (exportDatabase.menuModifiers != null && exportDatabase.menuModifiers!.length > 0) {
        await locator.get<ConnectionRepository>().menuModifierService!.saveIfNotExists(exportDatabase.menuModifiers!, exportDatabase.priceLabels!);
      }

      if (exportDatabase.menuItems != null && exportDatabase.menuItems!.length > 0) {
        await locator.get<ConnectionRepository>().menuItemService!.saveIfNotExists(exportDatabase.menuItems!, exportDatabase.priceLabels!, exportDatabase.menuCategories!, exportDatabase.menuModifiers!);
      }

      if (exportDatabase.menuItemGroups != null && exportDatabase.menuItemGroups!.length > 0) {
        await locator.get<ConnectionRepository>().menuItemService!.saveItemGroupIfNotExists(exportDatabase.menuItemGroups!, exportDatabase.menuItems!, exportDatabase.menuGroups!);
      }

      if (exportDatabase.dineInSections != null && exportDatabase.dineInSections!.length > 0) {
        await locator.get<ConnectionRepository>().dineInService!.saveIfNotExists(exportDatabase.dineInSections!);
      }

      if (exportDatabase.customers != null && exportDatabase.customers!.length > 0) {
        await locator.get<ConnectionRepository>().customerService!.saveIfNotExists(exportDatabase.customers!, exportDatabase.priceLabels!);
      }

      if (exportDatabase.surcharges != null && exportDatabase.surcharges!.length > 0) {
        await locator.get<ConnectionRepository>().surchargeService!.saveIfNotExists(exportDatabase.surcharges!);
      }

      //Extra =====================

      if (exportDatabase.roles != null && exportDatabase.roles!.length > 0) {
        await locator.get<ConnectionRepository>().roleService!.saveIfNotExists(exportDatabase.roles!);
      }

      if (exportDatabase.employees != null && exportDatabase.employees!.length > 0) {
        await locator.get<ConnectionRepository>().employeeService!.saveIfNotExists(exportDatabase.employees!);
      }

      //===========================

      if (exportDatabase.discounts != null && exportDatabase.discounts!.length > 0) {
        await locator.get<ConnectionRepository>().discountService!.saveIfNotExists(exportDatabase.discounts!, exportDatabase.roles!, exportDatabase.menuItems!);
      }

      if (exportDatabase.paymentMethods != null && exportDatabase.paymentMethods!.length > 0) {
        await locator.get<ConnectionRepository>().paymentMethodService!.saveIfNotExists(exportDatabase.paymentMethods!);
      }

      await locator.get<DialogService>().showDialog("Imported successfully", "Data Imported successfully");
      return true;
    } catch (e) {
      print(e.toString());
      await locator.get<DialogService>().showDialog("Error", "Data Import failed");

      return false;
    }
  }

  Future<void> exportData(bool menuIsSwitched, bool dineInIsSwitched, bool customerIsSwitched, bool employeeIsSwitched, bool surchargeIsSwitched, bool discountIsSwitched, bool paymentIsSwitched) async {
    try {
      ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
      ExportDatabase database = new ExportDatabase();
      if (menuIsSwitched) {
        database.menuCategories = await connectionRepository.menuCategoryService!.getAllMenuCategories();
        database.menuTypes = await connectionRepository.menuTypeService!.getActiveList();
        database.menuGroups = await connectionRepository.menuGroupService!.getAll();
        database.priceLabels = await connectionRepository.priceService!.getList();
        database.menuModifiers = await connectionRepository.menuModifierService!.getAll();
        database.menuItems = await connectionRepository.menuItemService!.getAll();
        database.menuItemGroups = await connectionRepository.menuItemService!.getMenuItemGroupAll();
      }

      if (dineInIsSwitched) {
        database.dineInSections = await connectionRepository.dineInService!.getAll();
      }

      if (employeeIsSwitched) {
        database.employees = await connectionRepository.employeeService!.getList();
        database.roles = await connectionRepository.roleService!.getAllRoles();
      }

      if (customerIsSwitched) {
        database.customers = await connectionRepository.customerService!.getAll();
      }

      if (surchargeIsSwitched) {
        database.surcharges = await connectionRepository.surchargeService!.getAll();
      }

      if (discountIsSwitched) {
        database.surcharges = await connectionRepository.surchargeService!.getAll();
      }

      if (paymentIsSwitched) {
        database.paymentMethods = await connectionRepository.paymentMethodService!.getAll();
      }

      File file = File(await getFilePath());
      file.writeAsString(jsonEncode(database.toMap()).toString());
      await locator.get<DialogService>().showDialog("Exported successfully", "Data exported successfully");
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<String> getFilePath() async {
    // await Permission.storage.request();
    // Directory? appDocumentsDirectory = await DownloadsPathProvider.downloadsDirectory;
    // String appDocumentsPath = appDocumentsDirectory!.path; // 2
    // String filePath = '$appDocumentsPath/MobData.invobk'; // 3

    // return filePath;
    return "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
