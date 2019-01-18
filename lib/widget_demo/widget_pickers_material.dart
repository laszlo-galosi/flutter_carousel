import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:intl/intl.dart';

class MaterialDateTimePicker extends StatelessWidget {
  const MaterialDateTimePicker(
      {Key key,
      this.label,
      this.valueDate,
      this.valueTime,
      this.onDateChanged,
      this.onTimeChanged,
      this.formatter})
      : super(key: key);

  final String label;
  final DateTime valueDate;
  final TimeOfDay valueTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueFormatter formatter;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: valueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != valueDate) onDateChanged(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: valueTime);
    if (picked != null && picked != valueTime) onTimeChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InputDropdown(
            labelText: label,
            valueText:
                formatter(valueDate) ?? DateFormat.yMMMMd().format(valueDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: valueTime != null
              ? InputDropdown(
                  valueText:
                      formatter(valueTime) ?? valueTime?.format(context) ?? "",
                  valueStyle: valueStyle,
                  onPressed: () {
                    _selectTime(context);
                  },
                )
              : Container(),
        )
      ],
    );
  }
}

class InputDropdown extends StatelessWidget {
  const InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
