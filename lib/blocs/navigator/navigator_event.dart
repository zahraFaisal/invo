import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/selected_customer.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/models/order/order_header.dart';

abstract class NavigatorEvent {}

class PopUp extends NavigatorEvent {}

class GoBackToHomePage extends NavigatorEvent {}

class NavigateToHomePage extends NavigatorEvent {}

class NavigateToDineInPage extends NavigatorEvent {
  NavigateToDineInPage();
}

class NavigateBackToOrderPage extends NavigatorEvent {
  DineInTable? table;
  NavigateBackToOrderPage({this.table});
}

class NavigateToRecallPage extends NavigatorEvent {
  final Service? service;
  NavigateToRecallPage({this.service});
}

class NavigateToPendingPage extends NavigatorEvent {
  NavigateToPendingPage();
}

class NavigateToOrderPage extends NavigatorEvent {
  final OrderHeader? order;
  final SelectedCustomer? customer;
  final List<OrderHeader>? orders;
  final Service? service;
  final DineInTable? table;

  NavigateToOrderPage({this.order, this.service, this.customer, this.table, this.orders});
}

class NavigateToCustomerPage extends NavigatorEvent {
  final String? phone;
  final Service? service;
  NavigateToCustomerPage(this.service, {this.phone});
}

class NavigateToTerminalPage extends NavigatorEvent {}

class NavigateToConnectionPage extends NavigatorEvent {}

class NavigateToDatabaseConnection extends NavigatorEvent {}

class NavigateToInvoConnectionPage extends NavigatorEvent {}

class NavigateToCashierPage extends NavigatorEvent {}

class NavigateToWizardPage extends NavigatorEvent {}

class NavigateToDownloadTemplatePage extends NavigatorEvent {}

class NavigateToActivationHomePage extends NavigatorEvent {}

class NavigateToActivationRegisterPage extends NavigatorEvent {}

class NavigateToActivationFormPage extends NavigatorEvent {}
