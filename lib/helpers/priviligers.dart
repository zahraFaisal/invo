import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/order/widgets/popup_modifiers.dart';
import 'dialog_service.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Privilege // : ViewModelCrust
{
  DialogService? _dialogService;
  Privilege() {
    _dialogService = locator<DialogService>();
  }

  Employee? employee;

  // private readonly IMyDialogService _dialogService;
  // public Privilege(IMyDialogService dialogService)
  // {
  //     _dialogService = dialogService;
  // }
  Future<bool> checkLogin(Privilages accessPoint) async {
    String number = "";
    Global globalTemp = locator.get<Global>();
    if (globalTemp.authEmployee == null) {
      // await defaultPasswordHint();
      number = await _dialogService!.showPasswordDialog();
      if (number == "") {
        return false;
      }
      //   return true;
      // }
      checkEmployee(number);
    } else {
      employee = globalTemp.authEmployee;
    }

    return checkAuthority(accessPoint, number);
    //return true;
  }

  Future<bool> forceLogin(Privilages accessPoint) async {
    String number = "";
    number = await _dialogService!.showPasswordDialog();
    checkEmployee(number);
    return checkAuthority(accessPoint, number);
  }

  void checkEmployee(String number) {
    ConnectionRepository temp = locator.get<ConnectionRepository>();
    employee = temp.employees!.firstWhereOrNull((f) => f.password == number);
  }

  bool checkAuthority(Privilages accessPoint, String number) {
    Global global = locator.get<Global>();
    if (employee == null) {
      _dialogService!.showDialog("Access Denied", "Access Denied"); //access Denied
      return false;
    } else {
      int x = employee!.get_security(accessPoint.index);

      if (x == 1) {
        global.setEmployee(employee!);
        return true;
      } else {
        _dialogService!.showDialog("Access Denied", "Access Denied"); //Forbidden_Access
        return false;
      }
    }
  }

  bool checkPrivilege(Privilages accessPoint) {
    Global globalTemp = locator.get<Global>();
    if (globalTemp.authEmployee == null) {
      _dialogService!.showDialog("Access Denied", "Access Denied");
      return false;
    } else {
      int x = globalTemp.authEmployee!.get_security(accessPoint.index);
      if (x == 1) {
        return true;
      } else {
        _dialogService!.showDialog("Access Denied", "Access Denied");
        return false;
      }
    }
  }

  ///check privilage without showing message
  bool checkPrivilege1(Privilages accessPoint) {
    Global globalTemp = locator.get<Global>();
    if (globalTemp.authEmployee == null) {
      return false;
    } else {
      int x = globalTemp.authEmployee!.get_security(accessPoint.index);
      if (x == 1) {
        return true;
      } else {
        return false;
      }
    }
  }

  // Future<String> showPasswordDialog(BuildContext context) async {
  //   GlobalKey<KeypadState> keypadState = new GlobalKey<KeypadState>();
  //   Keypad keypadWidget = Keypad(
  //                       key: keypadState,
  //                       isPassword: true,
  //                       isButtonOfHalfInclude: false,
  //                       EnterText: AppLocalizations.of(context)
  //                           .translate('Enter Your Password'),
  //                     );

  //   return await showDialog<String>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return Dialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  //         child: Container(
  //           width: 430,
  //           height: 720,
  //           child: Padding(
  //               padding: EdgeInsets.all(15),
  //               child: Column(
  //                 children: <Widget>[
  //                   Expanded(
  //                     flex: 6,
  //                     child: keypadWidget,
  //                   ),
  //                   Expanded(
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.stretch,
  //                       children: <Widget>[
  //                         Expanded(
  //                           child: KeypadButton(
  //                             text: AppLocalizations.of(context)
  //                                 .translate('Cancel'),
  //                             onTap: () {
  //                               Navigator.of(context).pop("");
  //                             },
  //                           ),
  //                         ),
  //                         SizedBox(),
  //                         Expanded(
  //                           child: KeypadButton(
  //                             text: AppLocalizations.of(context)
  //                                 .translate('Enter'),
  //                             onTap: () {
  //                               print(keypadState.currentState.text);
  //                               Navigator.of(context).pop(keypadState.currentState.text);
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<bool> check_report(Reports report_access) async
  // {
  //     String number = "";
  //     if (Globals.Instance.Logged_employee == null)
  //     {
  //         if (!(await _dialogService.passwordDialog()))
  //         {
  //             return false;
  //         }
  //         number = _dialogService.PasswordResault;
  //         check_employee(number);
  //     }
  //     else
  //     {
  //         _employee = Globals.Instance.Logged_employee;
  //     }

  //     return check_report_authority(report_access, number);

  //     //return true;
  // }

  // public async Task<bool> defaultPasswordHint()
  // {
  //     if (!Properties.Settings.Default.hideDefaultPasswordDialog)
  //     {
  //         bool resault = await _dialogService.msgDialog("Default Password", "Your Default Password is 1", "OK", "Don't Show Again");
  //         if (!resault) // OK
  //         {
  //             Properties.Settings.Default.hideDefaultPasswordDialog = true;
  //             Properties.Settings.Default.Save();
  //         }
  //     }

  //     return false;
  // }

  // public async Task<bool> check_login()
  // {
  //     string number = "";
  //     if (Globals.Instance.Logged_employee == null)
  //     {
  //         if (!(await _dialogService.passwordDialog()))
  //         {
  //             return false;
  //         }
  //         number = _dialogService.PasswordResault;
  //         check_employee(number);
  //     }
  //     else
  //     {
  //         _employee = Globals.Instance.Logged_employee;
  //     }

  //     Globals.Instance.Logged_employee = _employee;
  //     return true;
  // }

  //  bool Force_login(Privilages access_point)
  //   {
  //       string number = "";
  //       if (!(_dialogService.force_passwordDialog(out number)))
  //       {
  //           return false;
  //       }
  //       check_employee(number);
  //       if (check_authority(access_point, number))
  //       {
  //           return true;
  //       }
  //       else
  //       {
  //           return Force_login(access_point);
  //       }
  //   }

  // public async Task<bool> need_password(Privilages access_point)
  // {
  //     if (Globals.Instance.IsEditMode)
  //     {
  //         Messenger.Default.Send<Privilege.Privilages>(access_point, "show_security");
  //         _dialogService.SecurityForm();
  //         return false;
  //     }

  //     string number;
  //     if (!(await _dialogService.passwordDialog()))
  //     {
  //         return false;
  //     }
  //     number = _dialogService.PasswordResault;
  //     check_employee(number);

  //     return check_authority(access_point,number);
  //     //return true;
  // }

  // void _check_employee(string number)
  // {
  //     int resualt;
  //     if (int.TryParse(number, out resualt)) //check if number
  //     {
  //         //Password
  //         _employee = LocalData.getInstance().Employees.Where(f => f.password == number.ToString()).FirstOrDefault();
  //     }
  //     else
  //     {
  //         //MSR Code
  //         _employee = LocalData.getInstance().Employees.Where(f => f.msc_code == number.ToString()).FirstOrDefault();

  //     }
  // }

  //  bool check_privilege(Privilages access_point)
  // {
  //     if (Globals.Instance.Logged_employee == null)
  //     {
  //         _dialogService.msgDialog(Role.Security_Name((int)access_point).Replace('_', ' '), Language.Access_Denied, Language.OK);
  //         return false;
  //     }
  //     else
  //     {
  //         int x = (int)Globals.Instance.Logged_employee.job_title.get_security((int)access_point);
  //         if (x == 1)
  //         {
  //             return true;
  //         }
  //         else
  //         {
  //             _dialogService.msgDialog(Role.Security_Name((int)access_point).Replace('_', ' '), Language.Access_Denied, Language.OK);
  //             return false;
  //         }
  //     }
  // }

  // bool _check_privilege1(Privilages access_point)
  // {
  //     if (Globals.Instance.Logged_employee == null)
  //     {
  //         return false;
  //     }
  //     else
  //     {
  //         int x = (int)Globals.Instance.Logged_employee.job_title.get_security((int)access_point);
  //         if (x == 1)
  //         {
  //             return true;
  //         }
  //         else
  //         {
  //             return false;
  //         }
  //     }
  // }

  //  bool _check_authority(Privilages access_point,string number)
  // {
  //     if (_employee == null)
  //     {
  //         _dialogService.msgDialog(Role.Security_Name((int)access_point).Replace('_',' '), Language.Access_Denied, Language.OK);
  //         LocalData.getInstance().add_log_to_queue(Employee_log.Access_Denied(0,number,(int)access_point));
  //         return false;
  //     }
  //     else
  //     {
  //         int x = (int)_employee.job_title.get_security((int)access_point);

  //         if(x == 1){
  //             Globals.Instance.Logged_employee = _employee;
  //             return true;
  //         }else{
  //             LocalData.getInstance().add_log_to_queue(Employee_log.Access_Denied(_employee.id, number, (int)access_point));
  //             _dialogService.msgDialog(Role.Security_Name((int)access_point).Replace('_', ' '), Language.Forbidden_Access, Language.OK);
  //             return false;
  //         }
  //     }
  // }

  // bool _check_report_authority(Reports report_access, string number)
  // {
  //     if (_employee == null)
  //     {
  //         _dialogService.msgDialog("", Language.Access_Denied, Language.OK);
  //         return false;
  //     }
  //     else
  //     {
  //         bool x = MyConverter.ConvertToBoolean(_employee.job_title.GetReportSetting((int)report_access));

  //         if (x)
  //         {
  //             return true;
  //         }
  //         else
  //         {
  //             _dialogService.msgDialog("", Language.Forbidden_Access, Language.OK);
  //             return false;
  //         }
  //     }
  // }

  bool logOut({bool force = false}) {
    // if (LocalData.getInstance().terminal.No_Security)
    // {
    //     if (force)
    //      Globals.Instance.Logged_employee = null;
    // }
    // else
    // {
    //     Globals.Instance.Logged_employee = null;
    // }

    employee = null;
    locator.get<Global>().setEmployee(null);
    return true;
  }

  String Security_String =
      "New_Order_Security,Edit_Order_Security,ReOpen_Order_Security,Print_Order_Security,Settle_Order_Security,  Split_Order_Security,FollowUp_Order_Security,Void_Order_Security,Discount_Order_Security,Surcharge_Order_Security,  Driver_Dispatcher_Security,Reservation_Security,BackOffice_Security,DineIn_Security,TakeAway_Security,DriveThru_Security,Delivery_Security,                  Change_Item_Price_Security,Remove_Tax_Security,Pay_Credit_Security,Customer_Credit_Security,Edit_Mode_Security,       Show_Menu_Section,how_Employee_Section,Show_Report_Section,Show_Setting_Section,Add_MenuItem,Edit_MenuItem,Delete_MenuItem,  Add_MenuModifier,Edit_MenuModifier,Delete_MenuModifier,Add_MenuCategory,Edit_MenuCategory,Delete_MenuCategory,       Add_PriceLabel,Edit_PriceLabel,Delete_PriceLabel,Add_Surcharge,Edit_Surcharge,Delete_Surcharge,Add_Discount,Edit_Discount,Delete_Discount,        Add_Employee,Edit_Employee,Add_Equipment,Edit_Equipment,Delete_Equipment,Add_Role,Edit_Role,Delete_Role,Exit_Security,Open_Drawer,Employee_Attendence,Customers,Merge_Order,Sent_Email,Minimize,     Show_Inventory_Section,Add_Inventory_Item,Edit_Inventory_Item,Delete_Inventory_Item,Add_Inventory_Recipe,Edit_Inventory_Recipe,Delete_Inventory_Recipe, Add_PO,Edit_PO,Add_Supplier,Edit_Supplier,Delete_Supplier,Add_Inventory_Group,Edit_Inventory_Group,Delete_Inventory_Group,Add_Inventory_Location,Edit_Inventory_Location,Delete_Inventory_Location,      New_PhysicalCount_AllITem,New_PhysicalCount_ByGroup,New_PhysicalCount_ByLocation,New_PhysicalCount_ByItem,Edit_PhysicalCount,Calculate_PhysicalCount,Commit_PhysicalCount,    Add_Price_management,Edit_Price_management,Delete_Price_management,Add_Database,Export_Database,Import_Database,Backup_Database,Search_Security,Void_Payment,Driver_Option,Remove_Charge_Per_Hour,Remove_Minimum_Charge,Change_Table,Pending_Order,Manager_CashierOut,Setteld_Orders,Custom_Discount,Remove_Rounding,Retail,Catering";

  String get_security_name(int index) {
    List<String> x = Security_String.split(',');
    return x[index];
  }
}

enum Privilages {
  new_order, //0
  edit_order, //1
  reopen_order, //2
  print_order, //3
  settle_order, //4
  split_order, //5
  followUp_order, //6
  void_order, //7
  discount_order, //8
  surcharge_order, //9
  Driver_Dispatcher, //10
  Reservation, //11
  BackOffice, //12
  DineIn, //13
  TakeAway, //14
  DriveThru, //15
  Delivery, //16
  Change_Item_Price, //17
  Remove_Tax, //18
  Pay_Credit, //19
  Customer_Credit, //20
  Edit_Mode, //21
  Show_Menu_Section, //22
  Show_Employee_Section, // 23
  Show_Report_Section, // 24
  Show_Setting_Section, // 25
  Add_MenuItem, // 26
  Edit_MenuItem, //27
  Delete_MenuItem, //28
  Add_MenuModifier, // 29
  Edit_MenuModifier, // 30
  Delete_MenuModifier, // 31
  Add_MenuCategory, // 32
  Edit_MenuCategory, // 33
  Delete_MenuCategory, // 34
  Add_PriceLabel, // 35
  Edit_PriceLabel, // 36
  Delete_PriceLabel, // 37
  Add_Surcharge, //38
  Edit_Surcharge, // 39
  Delete_Surcharge, // 40
  Add_Discount, // 41
  Edit_Discount, // 42
  Delete_Discount, //43
  Add_Employee, //44
  Edit_Employee, // 45
  Add_Equipment, // 46
  Edit_Equipment, // 47
  Delete_Equipment, //48
  Add_Role, // 49
  Edit_Role, // 50
  Delete_Role, // 51
  Exit_Security, // 52
  Open_Drawer, // 53
  Employee_Attendence, //54
  Customers, // 55
  Merge_Order, // 56
  Sent_Email, // 57
  Minimize, // 58
  Show_Inventory_Section, // 59
  Add_Inventory_Item, // 60
  Edit_Inventory_Item, // 61
  Delete_Inventory_Item, // 62
  Add_Inventory_Recipe, // 63
  Edit_Inventory_Recipe, // 64
  Delete_Inventory_Recipe, //65
  Add_PO, // 66
  Edit_PO, // 67
  Add_Supplier, // 68
  Edit_Supplier, // 69
  Delete_Supplier, // 70
  Add_Inventory_Group, //71
  Edit_Inventory_Group, //72
  Delete_Inventory_Group, //73
  Add_Inventory_Location, //74
  Edit_Inventory_Location, //75
  Delete_Inventory_Location, //76
  New_PhysicalCount_AllITem, // 77
  New_PhysicalCount_ByGroup, // 78
  New_PhysicalCount_ByLocation, // 79
  New_PhysicalCount_ByItem, // 80
  Edit_PhysicalCount, // 81
  Calculate_PhysicalCount, // 82
  Commit_PhysicalCount, // 83
  Add_Price_management, // 84
  Edit_Price_management, // 85
  Delete_Price_management, // 86
  Add_Database, // 87
  Export_Database, // 88
  Import_Database, // 89
  Backup_Database, // 90
  Search_Security, // 91
  Void_Payment, // 92
  Driver_Option, //93
  Remove_Charge_Per_Hour, //94
  Remove_Minimum_Charge, // 95
  Change_Table, //96
  PendingOrder, // 97
  Manager_CashierOut, // 98
  Setteld_Orders, // 99 Paid Orders
  Custom_Discount, // 100
  Remove_Rounding, // 101
  Retail, // 102
  Catering, // 103
  Change_Order_Service_Type, //104
  Edit_MenuItem_Recipe, //105,
  Edit_MenuModifier_Recipe, //106
}

enum Reports {
  Sales_By_Item,
  Sales_By_Employee,
  Sales_By_Period,
  Sales_By_Category,
  Sales_By_Type,
  Sales_By_Table,
  Log_Report,
  Daily_Closing_Report,
  Cashier_History,
  Sales_By_Terminal,
  Sales_By_Table_Group,
  Cashier_Report,
  Sales_By_Menu,
  Sales_By_Group,
  Sales_By_Category_By_Item,
  MenuItem_Vs_MenuModifier,
  Service_Vs_Modifier,
  Employee_Attendence,
  Employee_Vs_Item,
  PayOut_Report,
  Driver_Report,
  Purchase_Report,
  Account_Balance,
  Payment_History,
  Guest_Report,
  CountDown_Movement,
  CountDown_List,
  Item_Movement,
  General_Inventory_Report,
  Sales_Vs_Usage,
  Inventory_Usage,
  Payment_Method_Report,
  Discount_Report,
  Surcharge_Report,
  Minimum_Charge_Report,
  Charge_Per_Hour_Report,
  Table_Usage,
  Void_Report,
  Tax_Report,
  Sales_By_Delivery_Area
}
