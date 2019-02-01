import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:intl/intl.dart';

class MaterialPickerWidget extends StatelessWidget {
  MaterialPickerWidget(
      {Key key,
      @required this.itemBuilder,
      this.onSelectedItemChanged,
      this.value,
      this.label,
      this.valueFormat});

  final String label;
  final dynamic value;
  final ValueChanged<dynamic> onSelectedItemChanged;
  final PickerItemListBuilder itemBuilder;
  final ValueFormatter valueFormat;

  @override
  Widget build(BuildContext context) {
    final items = itemBuilder(context).toList();
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        contentPadding: EdgeInsets.zero,
//          border: InputBorder.none
      ),
      isEmpty: items.isEmpty,
      child: DropdownButton<dynamic>(
        value: value,
        onChanged: (value) {
          onSelectedItemChanged(value);
        },
        items: items,
        isExpanded: true,
        elevation: 0,
      ),
    );
  }
}

class MaterialDateTimePicker extends StatelessWidget {
  const MaterialDateTimePicker(
      {Key key,
      this.mode = CupertinoDatePickerMode.date,
      this.label,
      this.value,
      this.onDateTimeChanged,
      this.valueFormat})
      : super(key: key);

  final CupertinoDatePickerMode mode;
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onDateTimeChanged;
  final ValueFormatter valueFormat;

  Future<void> _selectDate(BuildContext context) async {
    final time = TimeOfDay.fromDateTime(value);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != value)
      onDateTimeChanged(new DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute));
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = TimeOfDay.fromDateTime(value);
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      onDateTimeChanged(new DateTime(
          value.year, value.month, value.day, picked.hour, picked.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = res.textStylePicker;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: mode != CupertinoDatePickerMode.time
              ? InputDropdown(
                  labelText: label,
                  valueText:
                      valueFormat(value) ?? DateFormat.yMMMMd().format(value),
                  valueStyle: valueStyle,
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              : Container(),
        ),
        SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: mode != CupertinoDatePickerMode.date
              ? InputDropdown(
                  valueText:
                      TimeOfDay.fromDateTime(value).format(context) ?? "",
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
          border: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 1.0,
            color: res.colorDivider,
          )),
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
