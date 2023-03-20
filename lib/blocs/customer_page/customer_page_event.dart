import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';

abstract class CustomerPageEvent {}

class SelectContact extends CustomerPageEvent {
  CustomerContact contact;
  SelectContact(this.contact);
}

class AddContact extends CustomerPageEvent {}

class LoadContact extends CustomerPageEvent {
  final String phone;

  LoadContact(this.phone);
}

class EditContact extends CustomerPageEvent {}

class DeleteContact extends CustomerPageEvent {}

class SelectAddress extends CustomerPageEvent {
  CustomerAddress address;
  SelectAddress(this.address);
}

class AddAddress extends CustomerPageEvent {}

class EditAddress extends CustomerPageEvent {}

class DeleteAddress extends CustomerPageEvent {}

class SaveCustomer extends CustomerPageEvent {}

class CustomerPageGoBack extends CustomerPageEvent {}
