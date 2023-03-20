import 'package:invo_mobile/models/discount.dart';

class Role {
  String reportSettings;
  Discount? discount;
  int id_number;
  String name;
  String notifications;
  String security;
  bool in_active;
  bool isSelected;
  Role({
    this.reportSettings = "",
    this.id_number = 0,
    this.name = "",
    this.notifications = "",
    this.security = "",
    this.discount,
    this.in_active = false,
    this.isSelected = false,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        reportSettings: json["ReportSettings"] ?? "",
        name: json["name"] ?? "",
        notifications: json["notifications"] ?? "",
        security: json["security"] ?? "",
        id_number: json["id_number"] ?? 0);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id_number == 0 ? null : id_number,
      'name': name,
      'notifications': notifications,
      'security': security,
      'ReportSettings': reportSettings,
      'in_active': in_active == true ? 1 : 0
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id_number == 0 ? null : id_number,
      'id_number': id_number == 0 ? null : id_number,
      'name': name,
      'notifications': notifications,
      'security': security,
      'ReportSettings': reportSettings,
      'in_active': in_active == true ? 1 : 0
    };
    return map;
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
        reportSettings: map["ReportSettings"],
        name: map["name"],
        notifications: map["notifications"],
        security: map["security"],
        in_active: (map['in_active'] == 1) ? true : false,
        id_number: map['id'] ?? 0);
  }

  Map<String, bool>? privileges;
  Map<String, bool>? getSecurityList() {
    if (privileges != null) return privileges;
    privileges = new Map<String, bool>();
    int pos = 0;
    for (var item in securityString.split(',')) {
      privileges![item.replaceAll("_", " ").trim()] = get_security(pos) == 1 ? true : false;
      pos++;
    }
    return privileges;
  }

  setSecurityList() {
    String temp = privileges!.values.map((f) => f == true ? 1 : 0).join('').toString();
    security = temp;
  }

  get_security(int pos) {
    try {
      if (security != null) {
        return int.parse(security.split("")[pos]);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  String securityString = "New_Order,Edit_Other_Employee_Order,*ReOpen_Order,Print_Order,Settle_Order," +
      "*Split_Order,*FollowUp_Order,Void_Order,Discount_Order,Surcharge_Order," +
      "*Driver_Dispatcher,*Reservation,BackOffice,DineIn,TakeAway,DriveThru,Delivery," +
      "Change_Item_Price,*Remove_Tax,*Pay_Credit,*Customer_Credit,*Edit_Mode," +
      "*Show_Menu_Section,*Show_Employee_Section,*Show_Report_Section,*Show_Setting_Section,*Add_MenuItem,*Edit_MenuItem,*Delete_MenuItem," +
      "*Add_MenuModifier,*Edit_MenuModifier,*Delete_MenuModifier,*Add_MenuCategory,*Edit_MenuCategory,*Delete_MenuCategory," +
      "*Add_PriceLabel,*Edit_PriceLabel,*Delete_PriceLabel,*Add_Surcharge,*Edit_Surcharge,*Delete_Surcharge,*Add_Discount,*Edit_Discount,*Delete_Discount," +
      "*Add_Employee,*Edit_Employee,*Add_Equipment,*Edit_Equipment,*Delete_Equipment,*Add_Role,*Edit_Role,*Delete_Role,*Exit,Open_Drawer,*Employee_Attendence,*Customers,*Merge_Order,*Sent_Email,*Minimize," +
      "*Show_Inventory_Section,*Add_Inventory_Item,*Edit_Inventory_Item,*Delete_Inventory_Item,*Add_Inventory_Recipe,*Edit_Inventory_Recipe,*Delete_Inventory_Recipe," +
      "*Add_PO,*Edit_PO,*Add_Supplier,*Edit_Supplier,*Delete_Supplier,*Add_Inventory_Group,*Edit_Inventory_Group,*Delete_Inventory_Group,*Add_Inventory_Location,*Edit_Inventory_Location,*Delete_Inventory_Location," +
      "*New_PhysicalCount_AllITem,*New_PhysicalCount_ByGroup,*New_PhysicalCount_ByLocation,*New_PhysicalCount_ByItem,*Edit_PhysicalCount,*Calculate_PhysicalCount,*Commit_PhysicalCount," +
      "*Add_Price_management,*Edit_Price_management,*Delete_Price_management,*Add_Database,*Export_Database,*Import_Database,*Backup_Database,*Search,*Void_Payment,*Driver_Option,*Remove_Charge_Per_Hour," +
      "*Remove_Minimum_Charge,Change_Table,*Pending_Order,*Manager_CashierOut,Setteld_Orders,Custom_Discount,*Remove_Rounding,*Retail,*Catering";
}
