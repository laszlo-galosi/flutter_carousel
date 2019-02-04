import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';

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
    this.textAlign = TextAlign.start,
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
    this.initialValue,
    this.focusNode,
    this.nextFocusNode,
    this.onSaved,
    this.enabled = true,
  });

  /// The style to use for the text being edited.
  ///
  /// - Material: This text style is also used as the base style for the [TextFormField.decoration].
  /// If null, defaults to the `subhead` text style from the current [Theme].
  /// - Cupertino: see [CupertinoTextField.style]
  final TextStyle inputStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

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

//  @override
//  XTextEditFieldState createState() => XTextEditFieldState();

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
      );

  InputDecoration _materialDecoration(BuildContext context) => (decoration ??
          InputDecoration(
            border: UnderlineInputBorder(),
//            filled: true,
            hintText: hintText,
            labelText: labelText,
            labelStyle: labelStyle,
            hintStyle: hintStyle,
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

  @override
  bool isPlatformFlipped() => XTextEditField.platformFlipped;
}

class XTextEditFieldState extends FormFieldState<String>
    with
        XFormFieldStateMixin<String, InputDecorator, TextField,
            XTextEditField> {
  XTextEditFieldState({this.widgetBuilder});

  final FormFieldBuilder<String> widgetBuilder;

  @override
  FormFieldBuilder<String> customBuilder() => this.widgetBuilder;

  @override
  XTextEditField get widget => super.widget as XTextEditField;

  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      model.controller ?? _controller;

  XFormFieldModel get model => widget.fieldModel;

  @override
  void initState() {
    super.initState();
    if (model.controller == null) {
      _controller = TextEditingController(text: model.initialValue);
    } else {
      model.controller.addListener(_handleControllerChanged);
    }
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
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      if (!_effectiveController.text?.isEmpty ?? true)
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
      textAlign: model.textAlign ?? TextAlign.start,
      keyboardType: model.keyboardType,
      textCapitalization: model.textCapitalization ?? TextCapitalization.none,
      textInputAction: model.textInputAction ?? TextInputAction.next,
      obscureText: model.obscureText,
      scrollPadding: model.scrollPadding ?? defaultScrollPadding,
      autofocus: model.autofocus,
      focusNode: model.focusNode ?? new FocusNode(),
      controller: state._effectiveController,
      onChanged: field.didChange,
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
        prefix: model.labelText != null
            ? Text(model.labelText,
                style: model.labelStyle ?? kDefaultTextStyle)
            : null,
        keyboardType: model.keyboardType,
        style: model.inputStyle ?? kDefaultTextStyle,
        textAlign: model.textAlign ?? TextAlign.start,
        textCapitalization: model.textCapitalization ?? TextCapitalization.none,
        textInputAction: model.textInputAction ?? TextInputAction.next,
        obscureText: model.obscureText,
        scrollPadding: model.scrollPadding ?? defaultScrollPadding,
        autofocus: model.autofocus,
        focusNode: model.focusNode ?? new FocusNode(),
        controller: state._effectiveController,
        onChanged: field.didChange,
        onEditingComplete: model.onEditingComplete,
        onSubmitted:
            model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
        enabled: model.enabled,
      ),
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
  _XPasswordFieldState createState() =>
      _XPasswordFieldState(showRevealIcon: this.showRevealIcon);
}

class _XPasswordFieldState extends XTextEditFieldState {
  _XPasswordFieldState({@required this.showRevealIcon});

  bool _obscureText = true;
  final bool showRevealIcon;

  @override
  XFormFieldModel get model => widget.fieldModel;

  @override
  TextField createAndroidWidget(FormFieldState<String> field) {
    var theme = Theme.of(context);
    final XTextEditFieldState state = field as XTextEditFieldState;
    return new TextField(
      decoration: model.effectiveDecoration(context).copyWith(
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
                    ),
                  )
                : null,
          ),
      style: model.inputStyle ?? theme.textTheme.subhead,
      textAlign: model.textAlign ?? TextAlign.start,
      keyboardType: model.keyboardType,
      textCapitalization: model.textCapitalization ?? TextCapitalization.none,
      textInputAction: model.textInputAction ?? TextInputAction.next,
      obscureText: _obscureText,
      scrollPadding: model.scrollPadding ?? defaultScrollPadding,
      autofocus: model.autofocus,
      focusNode: model.focusNode ?? new FocusNode(),
      controller: state._effectiveController,
      onChanged: field.didChange,
      onSubmitted:
          model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
      onEditingComplete: model.onEditingComplete,
      enabled: model.enabled,
    );
  }

  @override
  createIosWidget(FormFieldState<String> field) {
    final XTextEditFieldState state = field as XTextEditFieldState;
    return InputDecorator(
        decoration: model
            .effectiveDecoration(context)
            .copyWith(errorText: field.errorText),
        child: new CupertinoTextField(
          placeholder: model.hintText,
          prefix: model.labelText != null
              ? Text(model.labelText,
                  style: model.labelStyle ?? kDefaultTextStyle)
              : null,
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
          textAlign: model.textAlign ?? TextAlign.start,
          textCapitalization:
              model.textCapitalization ?? TextCapitalization.none,
          textInputAction: model.textInputAction ?? TextInputAction.next,
          obscureText: _obscureText,
          autofocus: model.autofocus,
          focusNode: model.focusNode ?? new FocusNode(),
          controller: state._effectiveController,
          onChanged: field.didChange,
          onEditingComplete: model.onEditingComplete,
          onSubmitted:
              model.onFieldSubmitted ?? model.defaultOnFieldSubmitted(context),
          enabled: model.enabled,
        ));
  }
}
