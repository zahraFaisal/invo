import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/payment_method_form_page/payment_method_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/payment_method_form_page/payment_method_form_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class PaymentMethodFormPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<PaymentMethodFormEvent>.broadcast();
  Sink<PaymentMethodFormEvent> get eventSink => _eventController.sink;

  Property<PaymentMethodLoadState> method = new Property<PaymentMethodLoadState>();

  NavigatorBloc? _navigationBloc;
  PaymentMethodFormPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }
  Future loadPaymentMethod(int methodId) async {
    method.sinkValue(PaymentMethodIsLoading());
    if (methodId == null || methodId == 0) {
      method.sinkValue(PaymentMethodIsLoaded(new PaymentMethod(type: 1, in_active: false, rate: 1, symbol: "", after_decimal: 0)));
    } else
      method.sinkValue(PaymentMethodIsLoaded(await connectionRepository!.paymentMethodService!.get(methodId)));
  }

  void _mapEventToState(PaymentMethodFormEvent event) async {
    if (event is SavePaymentMethod) {
      event.method.in_active = false;
      locator.get<DialogService>().showLoadingProgressDialog();
      await connectionRepository!.paymentMethodService!.save(event.method);
      locator.get<DialogService>().closeDialog();
    }
  }

  String nameValidation = "";
  Future<bool> asyncValidate(PaymentMethod method) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.paymentMethodService!.checkIfNameExists(method);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }

  @override
  void dispose() {
    _eventController.close();
    method.dispose();
  }
}
