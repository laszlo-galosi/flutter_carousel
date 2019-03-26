import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart';
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
  const MaterialDateTimePicker({
    Key key,
    this.mode = CupertinoDatePickerMode.date,
    this.label,
    this.value,
    this.firstDate,
    this.lastDate,
    this.onDateTimeChanged,
    this.valueFormat,
    this.decoration,
    this.valueStyle,
    this.textAlign,
    this.isEmpty,
  }) : super(key: key);

  final CupertinoDatePickerMode mode;
  final String label;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateTimeChanged;
  final ValueFormatter valueFormat;
  final InputDecoration decoration;
  final TextStyle valueStyle;
  final TextAlign textAlign;
  final bool isEmpty;

  Future<void> _selectDate(BuildContext context) async {
    final time = TimeOfDay.fromDateTime(value);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: this.firstDate ?? DateTime(2015, 8),
        lastDate: this.lastDate ?? DateTime(2101));
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
                  textAlign: this.textAlign,
                  isEmpty: isEmpty ?? value == null,
                  decoration: this.decoration,
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              : Container(),
        ),
        SizedBox(width: mode != CupertinoDatePickerMode.date ? 12.0 : 0.0),
        Expanded(
          flex: mode != CupertinoDatePickerMode.date ? 3 : 0,
          child: mode != CupertinoDatePickerMode.date
              ? InputDropdown(
                  valueText:
                      TimeOfDay.fromDateTime(value).format(context) ?? "",
                  valueStyle: valueStyle ?? res.textStylePicker,
                  textAlign: this.textAlign,
                  decoration: this.decoration,
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
  const InputDropdown({
    Key key,
    this.icon,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.valueText,
    this.decoration,
    this.textAlign,
    this.valueStyle,
    this.onPressed,
    this.isEmpty,
  }) : super(key: key);

  final String labelText;
  final TextStyle labelStyle;
  final String hintText;
  final TextStyle hintStyle;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final InputDecoration decoration;
  final TextAlign textAlign;
  final Widget icon;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        isEmpty: isEmpty ?? true,
        decoration: (decoration ??
                InputDecoration(
                  labelText: labelText,
                  labelStyle: labelStyle,
                  hintText: hintText,
                  hintStyle: hintStyle,
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                    width: 1.0,
                    color: res.colorDivider,
                  )),
                ))
            .copyWith(hintText: null, labelText: null),
        baseStyle: valueStyle,
        textAlign: textAlign ?? TextAlign.start,
        child: Stack(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: alignmentFor(textAlign),
              child: Text(
                valueText,
                style: valueStyle,
//                textAlign: textAlign ?? TextAlign.start,
              ),
            ),
            Container(alignment: AlignmentDirectional.centerEnd, child: icon),
          ],
        ),
      ),
    );
  }
}
