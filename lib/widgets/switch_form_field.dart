import 'package:flutter/material.dart';

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    Text? title,
    Color? activeColor = Colors.green,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    bool autovalidate = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return SwitchListTile(
                activeColor: activeColor,
                title: title,
                value: state.value!,
                onChanged: (bool value) => state.didChange(value),
              );
            });
}
