import 'package:invo_mobile/models/custom/customer_list.dart';

abstract class CustomerListPageEvent {}

class LoadCustomerList extends CustomerListPageEvent {
  final String filter;

  LoadCustomerList(this.filter);
}


class ChangeCustomer extends CustomerListPageEvent {
  final String phone;

  ChangeCustomer(this.phone);
}




