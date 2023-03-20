import 'dart:async';

import 'package:invo_mobile/blocs/customer_page/customer_page_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/selected_customer.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';

import '../blockBase.dart';

class CustomerPageBloc extends BlocBase {
  final NavigatorBloc _navigationBloc;
  bool? selectCustomer; // indicate if customer page is shown to select customer for an order

  final _eventController = StreamController<CustomerPageEvent>.broadcast();
  Sink<CustomerPageEvent> get eventSink => _eventController.sink;

  Property<Customer> customer = new Property<Customer>();

  CustomerContact? selectedContact;
  CustomerAddress? selectedAddress;

  Property<bool> contactUpdate = new Property<bool>();
  Property<bool> addressUpdate = new Property<bool>();

  Service? service;
  CustomerPageBloc(this._navigationBloc, Service _service, String phone, bool _selectCustomer) {
    service = _service;
    selectCustomer = _selectCustomer;

    _eventController.stream.listen(_mapEventToState);
    _eventController.sink.add(LoadContact(phone));
  }

  void _mapEventToState(CustomerPageEvent event) async {
    if (event is SelectContact) {
      selectedContact = event.contact;
      contactUpdate.sinkValue(true);
    } else if (event is LoadContact) {
      loadCustomer(event.phone);
    } else if (event is AddContact) {
      CustomerContact contact = await locator.get<DialogService>().customerContactDialog(CustomerContact());

      if (contact == null) return;
      customer.value!.contacts.add(contact);
      contactUpdate.sinkValue(true);
    } else if (event is EditContact) {
      if (selectedContact != null) {
        CustomerContact contact = await locator.get<DialogService>().customerContactDialog(selectedContact!);
        if (contact == null) return;
        contactUpdate.sinkValue(true);
      }
    } else if (event is DeleteContact) {
      if (selectedContact != null) {
        if (customer.value!.activeContacts.where((f) => f.type == 1).length > 1) {
          selectedContact!.Is_Deleted = true;
          contactUpdate.sinkValue(true);
        }
      }
    } else if (event is SelectAddress) {
      selectedAddress = event.address;
      addressUpdate.sinkValue(true);
    } else if (event is AddAddress) {
      CustomerAddress address = await locator.get<DialogService>().customerAddressDialog(CustomerAddress(id: 0));
      if (address == null) return;
      customer.value!.addresses.add(address);
      addressUpdate.sinkValue(true);
    } else if (event is EditAddress) {
      if (selectedAddress != null) {
        CustomerAddress address = await locator.get<DialogService>().customerAddressDialog(selectedAddress!);
        if (address == null) return;
        addressUpdate.sinkValue(true);
      }
    } else if (event is DeleteAddress) {
      if (selectedAddress != null) {
        selectedAddress!.Is_Deleted = true;
        addressUpdate.sinkValue(true);
      }
    } else if (event is SaveCustomer) {
      locator.get<DialogService>().showLoadingProgressDialog();
      Customer? _customer_ = await locator.get<ConnectionRepository>().saveCustomer(customer.value!);
      locator.get<DialogService>().closeDialog();
      // ignore: curly_braces_in_flow_control_structures
      if (_customer_ != null) if (service != null) {
        String address = "";
        if (selectedAddress == null && _customer_.addresses.length > 0) selectedAddress = _customer_.addresses[0];

        if (selectedAddress != null) {
          address = selectedAddress!.fullAddress;
        }

        if (service!.id == 4 && address == "") return;

        if (selectCustomer!) {
          _navigationBloc.popBack(
            SelectedCustomer(customer: _customer_, contact: _customer_.contacts[0].contact, address: address),
          );
        } else {
          _navigationBloc.navigatorSink.add(PopUp());
          _navigationBloc.navigatorSink.add(NavigateToOrderPage(
              service: service!, customer: SelectedCustomer(customer: _customer_, contact: _customer_.contacts[0].contact, address: address)));
        }
      }
    } else if (event is CustomerPageGoBack) {
      _navigationBloc.navigatorSink.add(PopUp());
    }
  }

  void loadCustomer(String phone) async {
    Customer? _customer = await locator.get<ConnectionRepository>().loadCustomer(phone);
    if (_customer == null) {
      _customer = Customer(id_number: 0, name: "", contacts: [], addresses: []);
      _customer.contacts.add(CustomerContact(type: 1, contact: phone));
      // locator
      //     .get<DialogService>()
      //     .showDialog("", "Could not get customer information");
      // _navigationBloc.navigatorSink.add(PopUp());
      // return;
    }
    customer.sinkValue(_customer);
  }

  @override
  void dispose() {
    _eventController.close();
    customer.dispose();
    contactUpdate.dispose();
    addressUpdate.dispose();
    // TODO: implement dispose
  }
}
