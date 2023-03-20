import 'package:invo_mobile/models/customer/customer.dart';

class SelectedCustomer {
  Customer customer;
  String address;
  String contact;

  SelectedCustomer({required this.customer, this.contact = "", this.address = ""});
}
