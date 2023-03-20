import 'dart:async';

import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class DialogService {
  late Function(DialogRequest) _showDialogListener;
  late Completer<bool> _dialogCompleter;

  late Function _showLoadingListener;
  late Completer _loadingCompleter;

  late Function _showPasswordDialogListener;
  late Completer<String> _passwordDialogCompleter;

  late Function _showTelephoneDialogListener;
  late Completer<String> _telephoneDialogCompleter;

  late Function(DialogRequest) _showRecallTelephoneDialogListener;
  late Completer<String> _recallTelephoneDialogCompleter;

  late Function(NumberDialogRequest) _showNumberDialogListener;
  late Completer<String> _numberDialogCompleter;

  late Function(OrderHeader) _showPopupTicketListener;
  late Function(OrderHeader) _showPopupPendingTicketListener;

  late Completer _popupTicketCompleter;

  late Function _shortNoteDialogListener;
  late Completer<NoteDialogResponse> _shortNoteDialogCompleter;

  late Function(String) _noteDialogListener;
  late Completer<String> _noteDialogComplete;

  late Function _showLoadingProgressListener;
  late Completer _loadingProgressCompleter;

  late Function _showCustomerContactListener;
  late Completer _customerContactCompleter;

  late Function _showCustomerAddressListener;
  late Completer<CustomerAddress> _customerAddressCompleter;

  late Function _showBalanceDialogListener;
  late Completer _balanceDialogCompleter;

  late Function _closeDialog;

  void registerCloseDialogListener(closeDialog) {
    _closeDialog = closeDialog;
  }

  closeDialog() {
    _closeDialog();
  }

  /// Registers a callback function. Typically to show the dialog
//==================================================================================
  void registerLoadingProgressListener(showDialogListener) {
    _showLoadingProgressListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showLoadingProgressDialog() {
    _loadingProgressCompleter = Completer();
    _showLoadingProgressListener();
    return _loadingProgressCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogLoadingProgressComplete() {
    _loadingProgressCompleter.complete();
    _loadingProgressCompleter = Completer<dynamic>();
  }

//==================================================================================
  void registerBalanceDialogListener(Function showBalanceDialogListener) {
    _showBalanceDialogListener = showBalanceDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showBalanceDialog(String balance, {OrderHeader? orderHeader}) {
    _balanceDialogCompleter = Completer();
    if (orderHeader != null) {
      _showBalanceDialogListener(balance, orderHeader);
    } else {
      _showBalanceDialogListener(balance, null);
    }

    return _balanceDialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void balanceDialogComplete() {
    _balanceDialogCompleter.complete();
    _balanceDialogCompleter = Completer<dynamic>();
  }

  //==================================================================================
  void registerPasswordDialogListener(Function showDialogListener) {
    _showPasswordDialogListener = showDialogListener;
  }

  Future showPasswordDialog() {
    _passwordDialogCompleter = Completer();
    _showPasswordDialogListener();
    return _passwordDialogCompleter.future;
  }

  void passwordDialogComplete(String password) {
    _passwordDialogCompleter.complete(password);
    _passwordDialogCompleter = Completer<String>();
  }

  //==================================================================================
  void registerNumberDialogListener(dynamic Function(NumberDialogRequest) showDialogListener) {
    _showNumberDialogListener = showDialogListener;
  }

  Future showNumberDialog(NumberDialogRequest request) {
    _numberDialogCompleter = Completer();
    _showNumberDialogListener(request);
    return _numberDialogCompleter.future;
  }

  void numberDialogComplete(String number) {
    _numberDialogCompleter.complete(number);
    _numberDialogCompleter = Completer<String>();
  }

  //==================================================================================
  void registerTelephoneDialogListener(Function showDialogListener) {
    _showTelephoneDialogListener = showDialogListener;
  }

  Future showTelephoneDialog() {
    _telephoneDialogCompleter = Completer();
    _showTelephoneDialogListener();
    return _telephoneDialogCompleter.future;
  }

  void telephoneDialogComplete(String number) {
    _telephoneDialogCompleter.complete(number);
    _telephoneDialogCompleter = Completer<String>();
  }

  //==================================================================================
  void registerRecallTelephoneDialogListener(dynamic Function(DialogRequest) showDialogListener) {
    _showRecallTelephoneDialogListener = showDialogListener;
  }

  Future showRecallTelephoneDialog(DialogRequest request) {
    _recallTelephoneDialogCompleter = Completer();
    _showRecallTelephoneDialogListener(request);
    return _recallTelephoneDialogCompleter.future;
  }

  void recallTelephoneDialogComplete(String number) {
    _recallTelephoneDialogCompleter.complete(number);
    _recallTelephoneDialogCompleter = Completer<String>();
  }

  //==================================================================================
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<bool> showDialog(String title, String description, {String okButton = "OK", String cancelButton = ""}) {
    _dialogCompleter = Completer();
    _showDialogListener(DialogRequest(title: title, description: description, okButton: okButton, cancelButton: cancelButton));
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(bool resault) {
    _dialogCompleter.complete(resault);
    _dialogCompleter = Completer<bool>();
  }

  //==================================================================================
  void registerLoadingListener(showDialogListener) {
    _showLoadingListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showLoadingDialog() {
    _loadingCompleter = Completer();
    _showLoadingListener();
    return _loadingCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogLoadingComplete() {
    _loadingCompleter.complete();
    _loadingCompleter = Completer<dynamic>();
  }

  //==================================================================================
  void registerPopupTicketListener(showDialogListener) {
    _showPopupTicketListener = showDialogListener;
  }

  void registerPopupPendingTicketListener(showDialogListener) {
    _showPopupPendingTicketListener = showDialogListener;
  }

  Future showPopupPendingTicketDialog(OrderHeader order) {
    _popupTicketCompleter = Completer();
    _showPopupPendingTicketListener(order);
    return _popupTicketCompleter.future;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showPopupTicketDialog(OrderHeader order) {
    _popupTicketCompleter = Completer();
    _showPopupTicketListener(order);
    return _popupTicketCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void popupTicketComplete() {
    _popupTicketCompleter.complete();
    _popupTicketCompleter = Completer<dynamic>();
  }

  //==================================================================================
  void registerShortNoteDialogListener(Function showDialogListener) {
    _shortNoteDialogListener = showDialogListener;
  }

  Future shortNoteDialog() {
    _shortNoteDialogCompleter = Completer();
    _shortNoteDialogListener();
    return _shortNoteDialogCompleter.future;
  }

  void shortNoteDialogComplete(String note, String price) {
    _shortNoteDialogCompleter.complete(NoteDialogResponse(note: note, price: price));
    _shortNoteDialogCompleter = Completer<NoteDialogResponse>();
  }

  //==================================================================================
  void registerNoteDialogListener(dynamic Function(String) showDialogListener) {
    _noteDialogListener = showDialogListener;
  }

  Future noteDialog(String title) {
    _noteDialogComplete = Completer();
    _noteDialogListener(title);
    return _noteDialogComplete.future;
  }

  void noteDialogComplete(String note) {
    _noteDialogComplete.complete(note);
    _noteDialogComplete = Completer<String>();
  }

  //==================================================================================

  void registerCustomerContactDialogListener(Function showDialogListener) {
    _showCustomerContactListener = showDialogListener;
  }

  Future customerContactDialog(CustomerContact contact) {
    _customerContactCompleter = Completer();
    _showCustomerContactListener(contact);
    return _customerContactCompleter.future;
  }

  void customerContactDialogComplete(CustomerContact? contact) {
    _customerContactCompleter.complete(contact);
    _customerContactCompleter = Completer<dynamic>();
  }

  //==================================================================================

  void registerCustomerAddressDialogListener(Function showDialogListener) {
    _showCustomerAddressListener = showDialogListener;
  }

  Future<CustomerAddress> customerAddressDialog(CustomerAddress address) {
    _customerAddressCompleter = Completer();
    _showCustomerAddressListener(address);
    return _customerAddressCompleter.future;
  }

  void customerAddressDialogComplete(CustomerAddress? address) {
    _customerAddressCompleter.complete(address);
    _customerAddressCompleter = Completer<CustomerAddress>();
  }
}

class NoteDialogResponse {
  String? note;
  String? price;
  NoteDialogResponse({this.note, this.price});
}

class NumberDialogRequest {
  String? title;
  bool? hasHalfButton;
  bool? hasDotButton;
  int? maxLength = 0;
  NumberDialogRequest({this.title, this.hasHalfButton, this.hasDotButton, this.maxLength});
}

class DialogRequest {
  String? title;
  String? description;
  List<DialogButton>? actions;
  String? okButton;
  String? cancelButton;
  DialogRequest({this.title, this.description, this.actions, this.okButton, this.cancelButton});
}

class DialogButton {
  final String? content;
  final Void2VoidFunc? onTab;
  final bool? closeOnTab;
  DialogButton({this.content, this.onTab, this.closeOnTab});
}
