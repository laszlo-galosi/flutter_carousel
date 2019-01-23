import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/widget_pickers_cupertino.dart';
import 'package:flutter_carousel/widget_demo/widget_pickers_material.dart';

typedef ValueFormatter = String Function(dynamic value);

typedef PickerItemListBuilder = List<Widget> Function(BuildContext context);

typedef PickerListItemBuilder = Widget Function(
    dynamic value, BuildContext context);

abstract class XWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (customBuilder() != null) {
      return customBuilder()(context);
    }
    if (Platform.isAndroid) {
      return createAndroidWidget(context);
    } else if (Platform.isIOS) {
      return createIosWidget(context);
    }
    // platform not supported returns an error text.
    return Text(
      "Error ${Theme.of(context).platform} platform not supported yet.",
      style: res.textStyleError,
    );
  }

  WidgetBuilder customBuilder() => null;

  I createIosWidget(BuildContext context);

  A createAndroidWidget(BuildContext context);
}

class XPicker extends XWidget<CupertinoPickerWidget, MaterialPickerWidget> {
  XPicker(
      {Key key,
      @required this.value,
      @required this.onSelectedItemChanged,
      this.itemBuilder,
      this.values,
      this.label,
      this.valueFormat,
      this.indexMapper,
      this.widgetBuilder});

  final String label;
  final dynamic value;
  final ValueChanged<dynamic> onSelectedItemChanged;
  final Iterable<dynamic> values;
  final PickerListItemBuilder itemBuilder;
  final ValueFormatter valueFormat;
  final IndexValueMapper indexMapper;
  final WidgetBuilder widgetBuilder;

  @override
  CupertinoPickerWidget createIosWidget(BuildContext context) {
    assert(indexMapper != null,
        "indexMapper property is required to call onSelectedItemChanged.");
    return new CupertinoPickerWidget(
      key: this.key,
      itemBuilder: (context) {
        return values.map((v) => this.itemBuilder(v, context)).toList();
      },
      value: this.value,
      onSelectedItemChanged: this.onSelectedItemChanged,
      label: this.label,
      valueFormat: this.valueFormat,
      indexMapper: this.indexMapper,
    );
  }

  @override
  MaterialPickerWidget createAndroidWidget(BuildContext context) {
    return new MaterialPickerWidget(
      key: this.key,
      itemBuilder: (context) {
        return values.map((v) {
          return DropdownMenuItem<dynamic>(
              value: v, child: this.itemBuilder(v, context));
        }).toList();
      },
      value: this.value,
      onSelectedItemChanged: this.onSelectedItemChanged,
      label: this.label,
      valueFormat: this.valueFormat,
    );
  }

  @override
  WidgetBuilder customBuilder() => this.widgetBuilder;
}

class XDateTimePicker
    extends XWidget<CupertinoDateTimePicker, MaterialDateTimePicker> {
  XDateTimePicker({
    Key key,
    @required this.value,
    @required this.onDateTimeChanged,
    this.mode = CupertinoDatePickerMode.date,
    this.label,
    this.valueFormat,
    this.widgetBuilder,
  });

  final CupertinoDatePickerMode mode;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime value;
  final ValueFormatter valueFormat;
  final String label;
  final WidgetBuilder widgetBuilder;

  @override
  CupertinoDateTimePicker createIosWidget(BuildContext context) {
    return new CupertinoDateTimePicker(
      key: this.key,
      mode: this.mode,
      value: this.value,
      onDateTimeChanged: this.onDateTimeChanged,
      label: this.label,
      valueFormat: this.valueFormat,
    );
  }

  @override
  MaterialDateTimePicker createAndroidWidget(BuildContext context) {
    return new MaterialDateTimePicker(
      key: this.key,
      mode: this.mode,
      value: this.value,
      onDateTimeChanged: this.onDateTimeChanged,
      label: this.label,
      valueFormat: this.valueFormat,
    );
  }

  @override
  WidgetBuilder customBuilder() => this.widgetBuilder;
}
