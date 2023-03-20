import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/customer_page/customer_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/models/Service.dart';
// import 'package:invo_mobile/models/activation/customer.dart';
import 'package:invo_mobile/models/customer/customer.dart';

import 'package:invo_mobile/models/custom/selected_customer.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/back_office/settings.dart';
import 'package:invo_mobile/views/back_office/settings/menu_builder/form.dart';
import 'package:invo_mobile/views/back_office/settings/table_builder/form.dart';
import 'package:invo_mobile/views/cashier_function/index.dart';
import 'package:invo_mobile/views/connection/connect.dart';
import 'package:invo_mobile/views/connection/database_connection.dart';
import 'package:invo_mobile/views/connection/invo_connection.dart';
import 'package:invo_mobile/views/customer/index.dart';
import 'package:invo_mobile/views/dine_in/index.dart';
import 'package:invo_mobile/views/download_template/download_template_page.dart';
import 'package:invo_mobile/views/home/index.dart';
import 'package:invo_mobile/views/wizard/wizard_screen.dart';
import 'package:invo_mobile/views/order/index.dart';
import 'package:invo_mobile/views/recall/index.dart';
import 'package:invo_mobile/views/pending/index.dart';
import 'package:invo_mobile/views/cashier_report/cashier_report.dart';
import 'package:invo_mobile/views/daily_report/daily_sales.dart';
import 'package:invo_mobile/views/terminal/terminal_page.dart';
import 'package:invo_mobile/views/activation_home/index.dart';
import 'package:invo_mobile/views/activation_register/index.dart';
import 'package:invo_mobile/views/activation_form/index.dart';
import 'package:invo_mobile/models/customer/customer.dart';

import '../property.dart';
import 'navigator_event.dart';

class NavigatorBloc extends BlocBase {
  final _navigatorStateController = StreamController<NavigatorEvent>.broadcast();
  Sink<NavigatorEvent> get navigatorSink => _navigatorStateController.sink;

  GlobalKey<NavigatorState> navigatorKey;
  List<String> pageStack = List<String>.empty(growable: true);
  //same as current page
  Property<String> displayedPage = new Property<String>();
  String get currentPage {
    return (pageStack.length > 0) ? pageStack.last : "";
  }

  NavigatorBloc({required this.navigatorKey}) {
    _navigatorStateController.stream.listen((event) {
      if (event is GoBackToHomePage) {
        navigatorKey.currentState!.popUntil((pred) => pred.isFirst);

        String homePage = pageStack.first;
        pageStack.clear();
        pageStack.add(homePage);

        checkSecurity();

        displayedPage.sinkValue(currentPage);
      } else if (event is PopUp) {
        navigatorKey.currentState!.pop();

        if (pageStack.length > 0) pageStack.removeAt(pageStack.length - 1);

        if (currentPage == "HomePage") {
          //HomePage
          checkSecurity();
        }

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToHomePage) {
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        pageStack.add("HomePage");

        checkSecurity();

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToRecallPage) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => RecallPage(
              service: event.service!,
            ),
          ),
        );
        pageStack.add("RecallPage");

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToPendingPage) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => PendingPage(),
          ),
        );
        pageStack.add("RecallPage");

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToDineInPage) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => DineInPage(false),
          ),
        );
        pageStack.add("DineInPage");

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateBackToOrderPage) {
        navigatorKey.currentState!.pop();
        pageStack.removeAt(pageStack.length - 1);

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToOrderPage) {
        locator.registerSingleton<OrderPageBloc>(OrderPageBloc(this, event.service!, event.order, event.customer, event.table, event.orders));
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => OrderPage(),
          ),
        );
        pageStack.add("OrderPage");

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToCustomerPage) {
        locator.registerSingleton<CustomerPageBloc>(CustomerPageBloc(this, event.service!, event.phone!, false));
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => CustomerPage(),
          ),
        );
        pageStack.add("CustomerPage");

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToTerminalPage) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => TerminalPage()),
        );
        pageStack.add("TerminalPage");

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToConnectionPage) {
        navigatorKey.currentState!.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => ConnectPage()),
        );

        if (pageStack.length > 0) {
          String homePage = pageStack.first;
          pageStack.clear();
          pageStack.add(homePage);
          pageStack.add("ConnectionPage");
        }

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToDatabaseConnection) {
        navigatorKey.currentState!.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => DataBaseConnection()),
        );

        if (pageStack.length > 0) {
          String homePage = pageStack.first;
          pageStack.clear();
          pageStack.add(homePage);
          pageStack.add("ConnectionPage");
        }

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToInvoConnectionPage) {
        navigatorKey.currentState!.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => InvoConnectionPage(null)),
        );

        if (pageStack.length > 0) {
          String homePage = pageStack.first;
          pageStack.clear();
          pageStack.add(homePage);
          pageStack.add("ConnectionPage");
        }

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToCashierPage) {
        navigatorKey.currentState!.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => CashierFunction()),
        );

        if (pageStack.length > 0) {
          String homePage = pageStack.first;
          pageStack.clear();
          pageStack.add(homePage);
          pageStack.add("CashierPage");
        }

        displayedPage.sinkValue(currentPage);
      } else if (event is NavigateToWizardPage) {
        navigateToWizardPage();
      } else if (event is NavigateToDownloadTemplatePage) {
        navigatorKey.currentState!.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => DownloadTemplate()),
        );
      } else if (event is NavigateToActivationHomePage) {
        // navigatorKey.currentState.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => ActivationHome()),
        );
      } else if (event is NavigateToActivationRegisterPage) {
        // navigatorKey.currentState.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => ActivationRegister()),
        );
      } else if (event is NavigateToActivationFormPage) {
        // navigatorKey.currentState.popUntil((pred) => pred.isFirst);
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => ActivationForm()),
        );
      }
    });
  }
  void navigateToWizardPage() async {
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => WizardScreen()),
    );
  }

  Future<DineInTable> navigateToDineInPage() async {
    pageStack.add("DineInPage");
    displayedPage.sinkValue(currentPage);
    DineInTable temp = await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => DineInPage(true),
      ),
    );
    return temp;
  }

  void navigateToDownloadTemplatePage() async {
    pageStack.add("DownloadTemplate");
    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => DownloadTemplate(),
      ),
    );
  }

  Future<DineInTable> navigateToActivationRegisterPage() async {
    pageStack.add("ActivationRegister");
    displayedPage.sinkValue(currentPage);
    DineInTable temp = await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ActivationRegister(),
      ),
    );
    return temp;
  }

  Future<bool> navigateToConnectionPage() async {
    pageStack.add("ConnectionPage");

    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => ConnectPage()),
    );

    return true;
  }

  Future<bool> navigateToCashierPage() async {
    pageStack.add("CashierPage");

    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => CashierFunction()),
    );

    return true;
  }

  Future<DineInTable> navigateToActivationForm() async {
    pageStack.add("ActivationForm");
    displayedPage.sinkValue(currentPage);
    DineInTable temp = await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ActivationForm(),
      ),
    );
    return temp;
  }

  Future<bool> navigateToHomePage() async {
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
    pageStack.add("HomePage");

    checkSecurity();

    displayedPage.sinkValue(currentPage);

    return true;
  }

  Future<bool> navigateToTerminalPage() async {
    pageStack.add("TerminalPage");
    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => TerminalPage()),
    );

    return true;
  }

  Future<bool> navigateToDailySalesReport() async {
    pageStack.add("DailySalesPage");

    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => DailySalesPage()),
    );

    return true;
  }

  Future<bool> navigateToCashierReport() async {
    pageStack.add("CashierReportPage");

    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => CashierReportPage()),
    );

    return true;
  }

  void navigateToMainSettingsPage() async {
    pageStack.add("MainSettingsPage");
    displayedPage.sinkValue(currentPage);
    await navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => MainSettings()),
    );
  }

  void navigateToDataBaseConnectionPage() async {
    if (pageStack.length > 0) {
      String homePage = pageStack.first;
      pageStack.clear();
      pageStack.add(homePage);
      pageStack.add("ConnectionPage");
    }

    displayedPage.sinkValue(currentPage);

    // await navigatorKey.currentState.push(
    //   MaterialPageRoute(builder: (context) => MainSettings()),
    // );

    navigatorKey.currentState!.popUntil((pred) => pred.isFirst);
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => DataBaseConnection()),
    );
  }

  void navigateToMenuBuilderPage({bool active = false}) async {
    await navigatorKey.currentState!.push(
      MaterialPageRoute(
          builder: (context) => MenuBuilderForm(
                isTut: active,
              )),
    );
  }

  void navigateToTableFormPage({bool active = false}) async {
    await navigatorKey.currentState!.push(
      MaterialPageRoute(
          builder: (context) => TableBuilder(
                isActive: active,
              )),
    );
  }

  void popBack(dynamic value) {
    navigatorKey.currentState!.pop(value);

    pageStack.removeAt(pageStack.length - 1);

    displayedPage.sinkValue(currentPage);
  }

  Future<SelectedCustomer> navigateToCustomerPage(Service service, String phone) async {
    pageStack.add("CustomerPage");
    displayedPage.sinkValue(currentPage);
    locator.registerSingleton<CustomerPageBloc>(CustomerPageBloc(this, service, phone, true));

    SelectedCustomer temp = await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => CustomerPage(),
      ),
    );
    return temp;
  }

  Future<bool> navigateToOrderPage(NavigateToOrderPage event) async {
    locator.registerSingleton<OrderPageBloc>(OrderPageBloc(this, event.service!, event.order, event.customer, event.table, event.orders));
    pageStack.add("OrderPage");
    displayedPage.sinkValue(currentPage);
    return await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => OrderPage(),
      ),
    );
  }

  void checkSecurity() {
    if (!locator.get<ConnectionRepository>().terminal!.noSecurity) {
      Privilege privilage = new Privilege();
      privilage.logOut();
    }
  }

  @override
  void dispose() {
    _navigatorStateController.close();
    displayedPage.dispose();
    // TODO: implement dispose
  }
}
