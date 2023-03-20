class Customer {
  String contact_name;
  String contact_phone;
  String contact_email;

  Customer({this.contact_email = "", this.contact_name = "", this.contact_phone = ""});

  factory Customer.fromMap(Map<String, dynamic> map) {
    Customer customer = Customer();
    customer.contact_name = map['contact_name'];
    customer.contact_email = map['contact_email'];
    customer.contact_phone = map['contact_phone'];
    return customer;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'contact_name': contact_name,
      'contact_email': contact_email,
      'contact_phone': contact_phone,
    };
    return map;
  }
}
