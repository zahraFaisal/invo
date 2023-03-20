abstract class KeypadEvent {}

class OnClickButton extends KeypadEvent {
  final String buttonText;

  OnClickButton(this.buttonText);
}
