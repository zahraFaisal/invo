import 'package:invo_mobile/models/wizard.dart';

abstract class WizardPageEvent {}

class WizardPageGoBack extends WizardPageEvent {}

class WizardPageGoHome extends WizardPageEvent {}

class WizardCreateDB extends WizardPageEvent {
  final Wizard wizard;
  WizardCreateDB(this.wizard);
}



