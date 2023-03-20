import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({Key? key, this.labelText, this.selectedDate, this.selectedTime, this.selectDate, this.selectTime}) : super(key: key);

  final String? labelText;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime>? selectDate;
  final ValueChanged<TimeOfDay>? selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate!, firstDate: new DateTime(1970, 8), lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate!(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: selectedTime!);
    if (picked != null && picked != selectedTime) selectTime!(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? valueStyle = Theme.of(context).textTheme.bodyText1;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText!,
            valueText: new DateFormat.yMMMd().format(selectedDate!),
            valueStyle: valueStyle!,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime!.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class DatePicker extends StatefulWidget {
  DatePicker({
    Key? key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String? labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? selectDate;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate!, firstDate: new DateTime(1970, 8), lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) {
      widget.selectDate!(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? valueStyle = Theme.of(context).textTheme.bodyText1;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(5),
      child: Center(
        child: _InputDropdown(
          labelText: widget.labelText,
          valueText: DateFormat.yMMMd().format(selectedDate!),
          valueStyle: valueStyle!,
          onPressed: () {
            _selectDate(context);
          },
        ),
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({Key? key, this.child, this.labelText, this.valueText, this.valueStyle, this.onPressed}) : super(key: key);

  final String? labelText;
  final String? valueText;
  final TextStyle? valueStyle;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText!, style: const TextStyle(fontSize: 20)),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70),
          ],
        ),
      ),
    );
  }
}
