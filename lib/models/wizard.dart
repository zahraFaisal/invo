class Wizard {
  String company_name;
  String phone;
  String company_address1;
  String company_address2;
  String? image_path;
  String admin_name;

  String pass_code;
  String symbol;
  int dicamal;

  Wizard(
      {this.company_name = "",
      this.company_address1 = "",
      this.company_address2 = "",
      this.phone = "",
      this.image_path,
      this.admin_name = "",
      this.pass_code = "1",
      this.symbol = '\$',
      this.dicamal = 2});

  factory Wizard.fromMap(Map<String, dynamic> map) {
    Wizard wizard = Wizard();
    wizard.company_name = map['company_name'] ?? "";
    wizard.company_address1 = map['company_address1'] ?? "";
    wizard.company_address2 = map['company_address2'] ?? "";
    wizard.phone = map['phone'] ?? "";
    wizard.image_path = map['image_path'] ?? "";
    wizard.admin_name = map['admin_name'] ?? "";
    wizard.pass_code = map['pass_code'] ?? "";
    wizard.symbol = map['symbol'] ?? "";
    wizard.dicamal = map['dicamal'] ?? 0;
    return wizard;
  }
}
