import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/resources.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_pickers_cupertino.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_pickers_material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

// Default iOS style from HIG specs with larger font.
const TextStyle kDefaultTextStyle = TextStyle(
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.38,
  color: CupertinoColors.black,
  decoration: TextDecoration.none,
);

/// Padding for the [TextFormField.errorText] should be visible when
/// the keyboard is up.
const EdgeInsets defaultScrollPadding =
    EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 40.0);

class XFormFieldModel {
  const XFormFieldModel({
    this.controller,
    this.autovalidate = false,
    this.validator,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.keyboardType,
    this.inputStyle,
    this.focusedTextAlign = TextAlign.start,
    this.unfocusedTextAlign = TextAlign.start,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.scrollPadding,
    this.decoration,
    this.obscureText = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.maxLines,
    this.inputFormatters,
    this.initialValue,
    this.focusNode,
    this.nextFocusNode,
    this.onSaved,
    this.onChanged,
    this.enabled = true,
    this.prefix,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = OverlayVisibilityMode.always,
  });

  XFormFieldModel copyWith({
    TextEditingController controller,
    bool autovalidate = false,
    FormFieldValidator<String> validator,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    TextInputType keyboardType,
    TextStyle inputStyle,
    TextAlign focusedTextAlign,
    TextAlign unfocusedTextAlign,
    String labelText,
    TextStyle labelStyle,
    String hintText,
    TextStyle hintStyle,
    TextCapitalization textCapitalization,
    TextInputAction textInputAction,
    EdgeInsets scrollPadding,
    InputDecoration decoration,
    bool obscureText,
    bool autocorrect,
    bool autofocus,
    int maxLength,
    bool maxLengthEnforced,
    int maxLines,
    List<TextInputFormatter> inputFormatters,
    String initialValue,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    FormFieldSetter<String> onSaved,
    ValueChanged<String> onChanged,
    bool enabled,
    Widget prefix,
    OverlayVisibilityMode prefixMode,
    Widget suffix,
    OverlayVisibilityMode suffixMode,
  }) =>
      new XFormFieldModel(
        controller: controller ?? this.controller,
        autovalidate: autovalidate ?? this.autovalidate,
        validator: validator ?? this.validator,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
        keyboardType: keyboardType ?? this.keyboardType,
        inputStyle: inputStyle ?? this.inputStyle,
        focusedTextAlign: focusedTextAlign ?? this.focusedTextAlign,
        unfocusedTextAlign: unfocusedTextAlign ?? this.unfocusedTextAlign,
        labelText: labelText ?? this.labelText,
        labelStyle: labelStyle ?? this.labelStyle,
        hintText: hintText ?? this.hintText,
        hintStyle: hintStyle ?? this.hintStyle,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        textInputAction: textInputAction ?? this.textInputAction,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        decoration: decoration ?? this.decoration,
        obscureText: obscureText ?? this.obscureText,
        autocorrect: autocorrect ?? this.autocorrect,
        autofocus: autofocus ?? this.autofocus,
        maxLength: maxLength ?? this.maxLength,
        maxLengthEnforced: maxLengthEnforced ?? this.maxLengthEnforced,
        maxLines: maxLines ?? this.maxLines,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        initialValue: initialValue ?? this.initialValue,
        focusNode: focusNode ?? this.focusNode,
        nextFocusNode: nextFocusNode ?? this.nextFocusNode,
        onSaved: onSaved ?? this.onSaved,
        onChanged: onChanged ?? this.onChanged,
        enabled: enabled ?? this.enabled,
        prefix: prefix ?? this.prefix,
        prefixMode: prefixMode ?? this.prefixMode,
        suffix: suffix ?? this.suffix,
        suffixMode: suffixMode ?? this.suffixMode,
      );

  /// The style to use for the text being edited.
  ///
  /// - Material: This text style is also used as the base style for the [TextFormField.decoration].
  /// If null, defaults to the `subhead` text style from the current [Theme].
  /// - Cupertino: see [CupertinoTextField.style]
  final TextStyle inputStyle;

  /// How the text should be aligned horizontally when it is focused.
  ///
  /// Defaults to [TextAlign.start] and cannot be null.
  final TextAlign focusedTextAlign;

  /// How the text should be aligned horizontally when it is not focused.
  ///
  /// Defaults to [TextAlign.start] and cannot be null.
  final TextAlign unfocusedTextAlign;

  /// Text that describes the input field.
  ///
  ///
  final String labelText;

  /// The style to use for the [labelText] when the label is above (i.e.,
  /// vertically adjacent to) the input field.
  ///
  ///- Material: When the [labelText] is on top of the input field, the text uses the
  /// [hintStyle] instead.
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  ///- Cupertino: see [CupertinoTextField.prefix] widget to set the style explicitly.
  final TextStyle labelStyle;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// - Material: Displayed on top of the input [child] (i.e., at the same location on the
  /// screen where text may be entered in the input [child]) when the input
  /// [isEmpty] and either (a) [labelText] is null or (b) the input has the focus.
  /// - Cupertino: see [CupertinoTextField.placeholder]
  final String hintText;

  /// The style to use for the [hintText].
  ///
  /// -Material: Also used for the [labelText] when the [labelText] is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input [child]).
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  /// - Cupertino: see [CupertinoTextField.style]
  final TextStyle hintStyle;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  ///
  /// If true, the keyboard will open as soon as this text field obtains focus.
  /// Otherwise, the keyboard is only shown after the user taps the text field.
  ///
  /// Defaults to false. Cannot be null.
  final bool autofocus;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// When this is set to true, all the characters in the text field are
  /// replaced by U+2022 BULLET characters (•).
  final bool obscureText;

  /// Whether to enable autocorrection.
  ///
  /// Defaults to true. Cannot be null.
  final bool autocorrect;

  /// If true, this form field will validate and update its error text
  /// immediately after every change. Otherwise, you must call
  /// [FormFieldState.validate] to validate. If part of a [Form.autovalidate]
  /// is true that this value will be ignored.
  final bool autovalidate;

  final VoidCallback onEditingComplete;

  /// Called when the user indicates that they are done editing the text in the
  /// field. See: [TextFormField.onFieldSubmitted]
  final ValueChanged<String> onFieldSubmitted;

  final FocusNode nextFocusNode;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  ///
  /// The returned value is exposed by the [FormFieldState.errorText] property.
  /// The [TextFormField] uses this to override the [InputDecoration.errorText]
  /// value.
  final FormFieldValidator<String> validator;

  /// An optional method to call with the final value when the form is saved via
  /// [FormState.save].
  final FormFieldSetter<String> onSaved;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController controller;

  /// An optional value to initialize the form field to, or null otherwise.
  final String initialValue;

  /// Whether the form is able to receive user input.
  ///
  /// Defaults to true. If [autovalidate] is true, the field will be validated.
  /// Likewise, if this field is false, the widget will not be validated
  /// regardless of [autovalidate].
  final bool enabled;

  final InputDecoration decoration;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction textInputAction;

  final FocusNode focusNode;

  /// Configures padding to edges surrounding a [Scrollable] when the Textfield scrolls into view.
  ///
  /// When this widget receives focus and is not completely visible (for example scrolled partially
  /// off the screen or overlapped by the keyboard)
  /// then it will attempt to make itself visible by scrolling a surrounding [Scrollable], if one is present.
  /// This value controls how far from the edges of a [Scrollable] the TextField will be positioned after the scroll.
  ///
  /// Defaults to EdgeInserts.all(20.0).
  final EdgeInsets scrollPadding;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field, showing how many characters have been entered and how many are
  /// allowed. After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforced] is set to false. The TextField
  /// enforces the length with a [LengthLimitingTextInputFormatter], which is
  /// evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null or greater than zero. If set to null
  /// (the default), there is no limit to the number of characters allowed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforced] is set to false, then more than [maxLength]
  /// characters may be entered, but the error counter and divider will
  /// switch to the [decoration.errorStyle] when the limit is exceeded.
  final int maxLength;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// If [maxLength] is set, [maxLengthEnforced] indicates whether or not to
  /// enforce the limit, or merely provide a character counter and warning when
  /// [maxLength] is exceeded.
  final bool maxLengthEnforced;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// If this is 1 (the default), the text will not wrap, but will scroll
  /// horizontally instead.
  ///
  /// If this is null, there is no limit to the number of lines. If it is not
  /// null, the value must be greater than zero.
  final int maxLines;

  /// Called when the text being edited changes.
  final ValueChanged<String> onChanged;

  /// Optional input validation and formatting overrides.
  ///
  /// Formatters are run in the provided order when the text input changes.
  final List<TextInputFormatter> inputFormatters;

  /// An optional [Widget] to display before the text.
  final Widget prefix;

  /// Controls the visibility of the [prefix] widget based on the state of
  /// text entry when the [prefix] argument is not null.
  ///
  /// Defaults to [OverlayVisibilityMode.always] and cannot be null.
  ///
  /// Has no effect when [prefix] is null.
  final OverlayVisibilityMode prefixMode;

  /// An optional [Widget] to display after the text.
  final Widget suffix;

  /// Controls the visibility of the [suffix] widget based on the state of
  /// text entry when the [suffix] argument is not null.
  ///
  /// Defaults to [OverlayVisibilityMode.always] and cannot be null.
  ///
  /// Has no effect when [suffix] is null.
  final OverlayVisibilityMode suffixMode;

  ValueChanged<String> defaultOnFieldSubmitted(BuildContext context) {
    return (val) {
      if (textInputAction == TextInputAction.next && nextFocusNode != null) {
        focusNode?.unfocus();
        FocusScope.of(context).requestFocus(nextFocusNode);
      }
    };
  }

  InputDecoration effectiveDecoration(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return XTextEditField.platformFlipped
            ? _materialDecoration(context)
            : _cupertinoDecoration(context);
      case TargetPlatform.android:
      default:
        return XTextEditField.platformFlipped
            ? _cupertinoDecoration(context)
            : _materialDecoration(context);
    }
  }

  InputDecoration _cupertinoDecoration(BuildContext context) => InputDecoration(
        border: InputBorder.none,
//        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        prefix: prefix,
        suffix: suffix,
      );

  InputDecoration _materialDecoration(BuildContext context) => (decoration ??
          InputDecoration(
            border: UnderlineInputBorder(),
//            filled: true,
            hintText: hintText,
            labelText: labelText,
            labelStyle: labelStyle,
            hintStyle: hintStyle,
            prefix: prefix,
            suffix: suffix,
          ))
      .applyDefaults(Theme.of(context).inputDecorationTheme);
}

class XTextEditField extends FormField<String> {
  XTextEditField({
    Key key,
    @required this.fieldModel,
  }) : super(
            key: key,
            initialValue: fieldModel.controller != null
                ? fieldModel.controller.text
                : (fieldModel.initialValue ?? ''),
            onSaved: fieldModel.onSaved,
            validator: fieldModel.validator,
            autovalidate: fieldModel.autovalidate,
            enabled: fieldModel.enabled,
            builder: (field) {});

  final XFormFieldModel fieldModel;

  @override
  XTextEditFieldState createState() => XTextEditFieldState();

  static bool platformFlipped = false;
}

class XTextEditFieldState extends FormFieldState<String>
    with
        XFormFieldStateMixin<String, InputDecorator, TextField,
            XTextEditField> {
  XTextEditFieldState({this.widgetBuilder});

  final FormFieldBuilder<String> widgetBuilder;

  @override
  XTextEditField get widget => super.widget as XTextEditField;

  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      model.controller ?? _controller;

  XFormFieldModel get model => widget.fieldModel;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    if (model.controller == null) {
      _controller = TextEditingController(text: model.initialValue);
    } else {
      model.controller.addListener(_handleControllerChanged);
    }
    _focusNode = model.focusNode ?? new FocusNode();
/*
 //There is a flutter crash related to textAlign.
 https://github.com/flutter/flutter/issues/27546   
 _focusNode.addListener(_handleFocusChanged);
*/
    _handleFocusChanged();
  }

  TextAlign _textAlign = TextAlign.start;

  TextAlign get textAlign => _textAlign;

  set textAlign(TextAlign align) {
    setState(() => _textAlign = align);
  }

  void _handleFocusChanged() {
    textAlign = (model.focusNode?.hasFocus ?? false)
        ? model.focusedTextAlign
        : model.unfocusedTextAlign;
  }

  @override
  void didUpdateWidget(XTextEditField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldModel = oldWidget.fieldModel;
    if (model.controller != oldModel.controller) {
      oldModel.controller?.removeListener(_handleControllerChanged);
      model.controller?.addListener(_handleControllerChanged);

      if (oldModel.controller != null && model.controller == null) {
        _controller =
            TextEditingController.fromValue(oldModel.controller.value);
      }
      if (model.controller != null) {
        setValue(model.controller.text);
        if (oldModel.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    model.controller?.removeListener(_handleControllerChanged);
    model.focusNode?.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      if (_effectiveController.text?.isNotEmpty ?? false)
        didChange(_effectiveController.text);
      else
        _effectiveController.text = model.initialValue ?? '';
      model.focusNode?.unfocus();
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }

  @override
  TextField createAndroidWidget(FormFieldState<String> field) {
    var theme = Theme.of(field.context);
    final XTextEditFieldState state = field as XTextEditFieldState;
    return new TextField(
      decoration: model
          .effectiveDecoration(context)
          .copyWith(errorText: field.errorText),
      style: model.inputStyle ?? theme.textTheme.subhead,
      textAlign: textAlign,
      keyboardType: model.keyboardType,
      textCapitalization: model.textCapitalization ?? TextCapitalization.none,
      textInputAction: model.textInputAction ?? TextInputAction.next,
      obscureText: model.obscureText,
      scrollPadding: model.scrollPadding ?? defaultScrollPadding,
      autofocus: model.autofocus,
      maxLength: model.maxLength,
      maxLengthEnforced: model.maxLengthEnforced ?? true,
      maxLines: model.maxLines,
      inputFormatters: model.inputFormatters,
      focusNode: _focusNode,
      controller: state._effectiveController,
      onChanged: model.onChanged ?? field.didChange,
      onSubmitted:
          model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
      onEditingComplete: model.onEditingComplete,
      enabled: model.enabled,
    );
  }

  @override
  InputDecorator createIosWidget(FormFieldState<String> field) {
    final XTextEditFieldState state = field as XTextEditFieldState;
    return InputDecorator(
      decoration: model
          .effectiveDecoration(context)
          .copyWith(errorText: field.errorText),
      child: new CupertinoTextField(
          placeholder: model.hintText,
          prefix: model.prefix == null && model.labelText != null
              ? Text(model.labelText,
                  style: model.labelStyle ?? kDefaultTextStyle)
              : model.prefix,
          prefixMode: model.prefixMode,
          keyboardType: model.keyboardType,
          style: model.inputStyle ?? kDefaultTextStyle,
          textAlign: textAlign,
          textCapitalization:
              model.textCapitalization ?? TextCapitalization.none,
          textInputAction: model.textInputAction ?? TextInputAction.next,
          obscureText: model.obscureText,
          scrollPadding: model.scrollPadding ?? defaultScrollPadding,
          autofocus: model.autofocus,
          maxLength: model.maxLength,
          maxLengthEnforced: model.maxLengthEnforced,
          maxLines: model.maxLines,
          inputFormatters: model.inputFormatters,
          focusNode: model.focusNode ?? new FocusNode(),
          controller: state._effectiveController,
          onChanged: model.onChanged ?? field.didChange,
          onEditingComplete: model.onEditingComplete,
          onSubmitted:
              model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
          enabled: model.enabled),
    );
  }

  @override
  bool isPlatformFlipped() => XTextEditField.platformFlipped;
}

class XPasswordField extends XTextEditField {
  XPasswordField({
    Key key,
    @required XFormFieldModel fieldModel,
    this.showRevealIcon = true,
  }) : super(key: key, fieldModel: fieldModel);

  final bool showRevealIcon;

  @override
  XPasswordFieldState createState() =>
      XPasswordFieldState(showRevealIcon: this.showRevealIcon);
}

class XPasswordFieldState extends XTextEditFieldState {
  XPasswordFieldState({@required this.showRevealIcon});

  bool _obscureText = true;
  final bool showRevealIcon;

  @override
  XFormFieldModel get model => widget.fieldModel;

  InputDecoration get decoration =>
      (model.decoration ?? model.effectiveDecoration(context))
          .copyWith(errorText: this.errorText);

  @override
  TextField createAndroidWidget(FormFieldState<String> field) {
    var theme = Theme.of(context);
    final XTextEditFieldState state = field as XTextEditFieldState;
    return new TextField(
      decoration: decoration.copyWith(
        errorText: field.errorText,
        suffixIcon: this.showRevealIcon
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                      _obscureText ? 'show password' : 'hide password',
//                      size: 18.0,
                ),
              )
            : null,
      ),
      style: model.inputStyle ?? theme.textTheme.subhead,
      textAlign: model.focusNode?.hasFocus ?? false
          ? model.focusedTextAlign
          : model.unfocusedTextAlign,
      keyboardType: model.keyboardType,
      textCapitalization: model.textCapitalization ?? TextCapitalization.none,
      textInputAction: model.textInputAction ?? TextInputAction.next,
      obscureText: _obscureText,
      scrollPadding: model.scrollPadding ?? defaultScrollPadding,
      autofocus: model.autofocus,
      maxLength: model.maxLength,
      maxLengthEnforced: model.maxLengthEnforced ?? true,
      maxLines: model.maxLines,
      inputFormatters: model.inputFormatters,
      focusNode: model.focusNode ?? new FocusNode(),
      controller: state._effectiveController,
      onChanged: model.onChanged ?? field.didChange,
      onSubmitted:
          model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
      onEditingComplete: model.onEditingComplete,
      enabled: model.enabled,
    );
  }

  @override
  InputDecorator createIosWidget(FormFieldState<String> field) {
    final XTextEditFieldState state = field as XTextEditFieldState;
    return InputDecorator(
        decoration: decoration,
        child: new CupertinoTextField(
          placeholder: model.hintText,
          prefix: model.labelText != null
              ? Text(model.labelText,
                  style: model.labelStyle ?? kDefaultTextStyle)
              : model.prefix,
          suffix: this.showRevealIcon
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                    semanticLabel:
                        _obscureText ? 'show password' : 'hide password',
                  ))
              : null,
          keyboardType: model.keyboardType,
          style: model.inputStyle ?? kDefaultTextStyle,
          textAlign: model.focusNode?.hasFocus ?? false
              ? model.focusedTextAlign
              : model.unfocusedTextAlign,
          textCapitalization:
              model.textCapitalization ?? TextCapitalization.none,
          textInputAction: model.textInputAction ?? TextInputAction.next,
          obscureText: _obscureText,
          autofocus: model.autofocus,
          maxLength: model.maxLength,
          maxLengthEnforced: model.maxLengthEnforced ?? true,
          maxLines: model.maxLines,
          inputFormatters: model.inputFormatters,
          focusNode: model.focusNode ?? new FocusNode(),
          controller: state._effectiveController,
          onChanged: model.onChanged ?? field.didChange,
          onEditingComplete: model.onEditingComplete,
          onSubmitted:
              model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
          enabled: model.enabled,
        ));
  }
}

typedef EmptyEvaluate = bool Function(dynamic);
typedef TextStyleEvaluate = TextStyle Function(dynamic);

class XDatePickerFieldModel extends XFormFieldModel {
  final CupertinoDatePickerMode mode;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;
  final ValueFormatter valueFormat;
  final TextStyleEvaluate valueStyle;
  final FormFieldValidator<DateTime> dateTimeValidator;
  final Widget dropDownIcon;

  XDatePickerFieldModel({
    this.mode,
    this.onDateTimeChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.valueFormat,
    this.valueStyle,
    this.dateTimeValidator,
    this.dropDownIcon,
    bool autovalidate = false,
    ValueChanged<String> onFieldSubmitted,
    TextAlign focusedTextAlign = TextAlign.start,
    String labelText,
    TextStyle labelStyle,
    String hintText,
    TextStyle hintStyle,
    TextAlign textAlign,
    InputDecoration decoration,
    bool enabled = true,
    Widget prefix,
    OverlayVisibilityMode prefixMode = OverlayVisibilityMode.always,
    Widget suffix,
    OverlayVisibilityMode suffixMode = OverlayVisibilityMode.always,
  }) : super(
          autovalidate: autovalidate,
          onFieldSubmitted: onFieldSubmitted,
          focusedTextAlign: textAlign,
          labelText: labelText,
          labelStyle: labelStyle,
          hintText: hintText,
          hintStyle: hintStyle,
          enabled: enabled,
          prefix: prefix,
          prefixMode: prefixMode,
          suffix: suffix,
          suffixMode: suffixMode,
          decoration: decoration,
        );
}

class XDatePickerField extends FormField<DateTime> {
  final XDatePickerFieldModel fieldModel;

  XDatePickerField({Key key, @required this.fieldModel})
      : super(
            key: key,
            initialValue: fieldModel.value,
            onSaved: fieldModel.onDateTimeChanged,
            validator: fieldModel.dateTimeValidator,
            autovalidate: fieldModel.autovalidate,
            enabled: fieldModel.enabled,
            builder: (field) {});

  @override
  XDatePickerFieldState createState() => XDatePickerFieldState();
}

class XDatePickerFieldState extends FormFieldState<DateTime>
    with XFormFieldStateMixin<DateTime, Widget, Widget, XDatePickerField> {
  XDatePickerFieldState();

  Logger _logger = newLogger('XDatePickerFieldState');

  @override
  XDatePickerField get widget => super.widget as XDatePickerField;

  XDatePickerFieldModel get model => widget.fieldModel;

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    _logger.fine("didChange $value");
    (widget.key as GlobalKey<XDatePickerFieldState>).currentState.validate();
  }

  bool get isEmpty =>
      value == null /*|| value == model.initialDate ?? model.firstDate*/;

  DateTime get safeValue => value ?? model.initialDate;

  InputDecoration get decoration =>
      (model.decoration ?? model.effectiveDecoration(context))
          .copyWith(errorText: this.errorText);

  Future<void> _selectDate(BuildContext context) async {
    final time = TimeOfDay.fromDateTime(safeValue);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: safeValue,
        firstDate: model.firstDate ?? DateTime(2015, 8),
        lastDate: model.lastDate ?? DateTime(2101));
    if (picked != null && picked != value) {
      final newValue = new DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
      didChange(newValue);
      model.onDateTimeChanged(newValue);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = TimeOfDay.fromDateTime(safeValue);
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      final newValue = new DateTime(safeValue.year, safeValue.month,
          safeValue.day, picked.hour, picked.minute);
      didChange(newValue);
      model.onDateTimeChanged(newValue);
    }
  }

  Widget get defaultDropDownIcon => Icon(Icons.arrow_drop_down,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade700
          : Colors.white70);

  @override
  Widget createAndroidWidget(FormFieldState<DateTime> field) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: model.mode != CupertinoDatePickerMode.time ? 5 : 0,
          child: model.mode != CupertinoDatePickerMode.time
              ? InputDropdown(
                  labelText: model.labelText ?? model.decoration?.labelText,
                  labelStyle: model.labelStyle ?? model.decoration?.labelStyle,
                  hintText: model.hintText,
                  hintStyle: model.hintStyle,
                  valueText: model.valueFormat != null
                      ? model.valueFormat(value)
                      : DateFormat.yMMMMd().format(value),
                  valueStyle: model.valueStyle(value),
                  textAlign: model.focusedTextAlign,
                  icon: model.dropDownIcon ?? defaultDropDownIcon,
                  isEmpty: isEmpty,
                  decoration: decoration,
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              : Container(),
        ),
        SizedBox(
            width:
                model.mode == CupertinoDatePickerMode.dateAndTime ? 12.0 : 0.0),
        Expanded(
          flex: model.mode != CupertinoDatePickerMode.date ? 3 : 0,
          child: model.mode != CupertinoDatePickerMode.date
              ? InputDropdown(
                  valueText:
                      TimeOfDay.fromDateTime(safeValue).format(context) ?? "",
                  valueStyle: model.valueStyle != null
                      ? model.valueStyle(value)
                      : textStylePicker,
                  textAlign: model.focusedTextAlign,
                  icon: model.dropDownIcon ?? defaultDropDownIcon,
                  decoration: decoration,
                  onPressed: () {
                    _selectTime(context);
                  },
                )
              : Container(),
        ),
      ],
    );
  }

  @override
  Widget createIosWidget(FormFieldState<DateTime> field) {
    return InputDecorator(
        isEmpty: model.dateTimeValidator != null,
        decoration: decoration,
        child: GestureDetector(
            onTap: () {
              showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoBottomPicker(
                        picker: CupertinoDatePicker(
                            mode: model.mode ?? CupertinoDatePickerMode.date,
                            minimumDate: model.firstDate ?? DateTime(2015, 8),
                            maximumDate: model.lastDate ?? DateTime(2101),
                            use24hFormat: true,
                            initialDateTime: safeValue,
                            onDateTimeChanged: (date) {
                              didChange(date);
                              model.onDateTimeChanged(date);
                            }));
                  });
            },
            child: CupertinoListItem(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.transparent)),
                children: [
                  Text(
                      model.labelText ??
                          model.decoration?.labelText ??
                          'DateTime',
                      style: model.decoration?.labelStyle),
                  Text(
                    model.valueFormat != null
                        ? model.valueFormat(safeValue)
                        : DateFormat.yMd().format(value),
                    style: model.valueStyle == null
                        ? const TextStyle(color: CupertinoColors.inactiveGray)
                        : model.valueStyle(safeValue),
                  )
                ])));
  }

  @override
  bool isPlatformFlipped() => XTextEditField.platformFlipped;
}
