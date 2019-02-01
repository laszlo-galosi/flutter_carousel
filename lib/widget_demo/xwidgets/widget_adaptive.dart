import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/xwidgets/widget_pickers_cupertino.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_pickers_material.dart';

typedef ValueFormatter = String Function(dynamic value);

typedef PickerItemListBuilder = List<Widget> Function(BuildContext context);

typedef PickerListItemBuilder = Widget Function(
    dynamic value, BuildContext context);

abstract class XStatelessWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (customBuilder() != null) {
      return customBuilder()(context);
    }
    if (Platform.isAndroid) {
//      return createAndroidWidget(context, this);
      return isPlatformFlipped()
          ? createIosWidget(context)
          : createAndroidWidget(context);
    } else if (Platform.isIOS) {
      return isPlatformFlipped()
          ? createAndroidWidget(context)
          : createIosWidget(context);
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

  bool isPlatformFlipped() => XStatelessWidget.platformFlipped;

  static bool platformFlipped = false;
}

/// Signature for building the widget representing the form field.
///
/// Used by [FormField.builder].
typedef XFormFieldBuilder<T> = Widget Function(FormFieldState<T> field);

mixin XFormFieldMixin<V, I extends FormField<V>, A extends FormField<V>>
    on FormField<V> {
  I createIosWidget(FormFieldState<V> field);

  A createAndroidWidget(FormFieldState<V> field);

  bool isPlatformFlipped() => false;
}

mixin XFormFieldStateMixin<V, I extends Widget, A extends Widget,
    W extends StatefulWidget> on FormFieldState<V> {
  @override
  Widget build(BuildContext context) {
    //Call super build, to call [FormFieldState._register]
    super.build(context);
    if (customBuilder() != null) {
      return customBuilder()(this);
    }
    if (Platform.isAndroid) {
//      return createAndroidWidget(context, this);
      return isPlatformFlipped()
          ? createIosWidget(this)
          : createAndroidWidget(this);
    } else if (Platform.isIOS) {
      return isPlatformFlipped()
          ? createAndroidWidget(this)
          : createIosWidget(this);
    }
    // platform not supported returns an error text.
    return Text(
      "Error ${Theme.of(context).platform} platform not supported yet.",
      style: res.textStyleError,
    );
  }

  I createIosWidget(FormFieldState<V> field) => null;

  A createAndroidWidget(FormFieldState<V> field) => null;

  FormFieldBuilder<V> customBuilder() => null;

  bool isPlatformFlipped() => false;
}

class XButton extends XStatelessWidget<CupertinoButton, MaterialButton> {
  XButton(
      {Key key,
      @required this.child,
      this.padding,
      this.color,
      this.disabledColor,
      this.minSize = 44.0,
      this.pressedOpacity = 0.1,
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      this.enabled = true,
      @required this.onPressed});

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry padding;

  /// The color of the button's background.
  final Color color;

  /// The color of the button's background when the button is disabled.
  final Color disabledColor;

  /// The callback that is called when the button is tapped or otherwise activated.

  final VoidCallback onPressed;

  /// Minimum size of the button.
  /// Defaults to 44.0 which the iOS Human Interface Guideline recommends as the
  final double minSize;

  /// The opacity that the button will fade to when it is pressed.
  /// The button will have an opacity of 1.0 when it is not pressed.
  ///
  /// This defaults to 0.1. If null, opacity will not change on pressed if using
  /// your own custom effects is desired.
  final double pressedOpacity;

  /// The radius of the button's corners when it has a background color.
  ///
  /// Defaults to round corners of 8 logical pixels.
  final BorderRadius borderRadius;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  final bool enabled;

  @override
  CupertinoButton createIosWidget(BuildContext context) {
    return new CupertinoButton(
      child: this.child,
      padding: this.padding,
      onPressed: enabled ? this.onPressed : null,
      color: this.color ?? Theme.of(context).accentColor,
      disabledColor: this.disabledColor,
      minSize: this.minSize,
      pressedOpacity: this.pressedOpacity,
      borderRadius: this.borderRadius,
    );
  }

  @override
  MaterialButton createAndroidWidget(BuildContext context) {
    return new MaterialButton(
      child: this.child,
      padding: this.padding,
      onPressed: enabled ? this.onPressed : null,
      color: this.color ?? Theme.of(context).accentColor,
      disabledColor: this.disabledColor,
    );
  }
}

class XPicker
    extends XStatelessWidget<CupertinoPickerWidget, MaterialPickerWidget> {
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
    extends XStatelessWidget<CupertinoDateTimePicker, MaterialDateTimePicker> {
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
