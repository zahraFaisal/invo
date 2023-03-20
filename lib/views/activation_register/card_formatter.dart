import 'package:flutter/services.dart';

class CardFormatter extends TextInputFormatter {
  final String? sample;
  final String? separator;
  CardFormatter({this.sample, this.separator}) {
    assert(sample != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample!.length) return oldValue;
        if (newValue.text.length < sample!.length && sample![newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
          );
        }
      }
    }

    return newValue;
  }
}
