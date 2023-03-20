class CustomerList {
  String contact;
  int customer_id;
  String name;

  CustomerList({
    this.contact = "",
    this.customer_id = 0,
    this.name = "",
  });

  factory CustomerList.fromMap(Map<String, dynamic> map) {
    CustomerList customerList = CustomerList();
    customerList.contact = map['customer_contact'] ?? "";
    customerList.customer_id = map['customer_id'] ?? 0;
    customerList.name = map['name'] ?? "";
    return customerList;
  }

  factory CustomerList.fromJson(Map<String, dynamic> json) {
    return CustomerList(
      contact: json['customer_contact'] ?? "",
      customer_id: json['customer_id'] ?? 0,
      name: json['name'] ?? "",
    );
  }
}
