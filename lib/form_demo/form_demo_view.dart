import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel/form_demo/form_demo_view_model.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive_form.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

const String EMAIL_PATTERN =
    r"^[a-zóüöúőűáéíA-ZÓÜÖÚŐŰÁÉÍ00-9.!#\$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1," +
        "3}\\.[0-9]{1,3}\\" +
        ".[0-9]{1,3}])|(([a-zóüöúőűáéíA-ZÓÜÖÚŐŰÁÉÍ0\\-0-9]+\\.)+[a-zA-Z]{2,}))\$";

//final Logger log = new Logger('FormDemo');

class FormDemoPageWidget extends StatelessWidget {
  FormDemoPageWidget({Key key, @required this.viewModel});

  final FormDemoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<FormDemoViewModel>(
      model: viewModel,
      child: SafeArea(top: false, bottom: false, child: new FormWidget()),
    );
  }
}

class FormWidget extends StatefulWidget {
  FormWidget({Key key});

  _FormWidgetState createState() => new _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  ScrollController _scrollController = new ScrollController();

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  FormDemoViewModel _viewModel;

  bool _autovalidate = false;

  static final _logger = newLogger("FormDemoPage");

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  FocusNode _focusNodeBy(String key) {
    return _viewModel
            .keyMap[key]?.currentState?.widget?.fieldModel?.focusNode ??
        new FocusNode();
  }

  final iosIcon = Image.asset(
    'images/apple-logo.png',
    width: 24.0,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return ScopedModelDescendant<FormDemoViewModel>(
        builder: (context, _, model) {
      _viewModel = model;
      return new Scaffold(
          key: _viewModel.scaffoldKey,
          //Need this to fix TextFormField keyboard overlapping widgets
          // when using nested Scaffold.
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(navState.selectedItem?.title ?? "",
                style: res.textStyleTitleDark),
            leading: IconButton(
                icon: Icon(
                    navState.shouldGoBack ? res.backIcon(context) : Icons.menu),
                onPressed: () {
                  if (navState.shouldGoBack) {
                    navState.navigator.currentState.pop();
                  } else {
                    RootScaffold.openDrawer(context);
                  }
                }),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Platform.isAndroid
                    ? (_viewModel.platformFlipped
                        ? Icon(Icons.android)
                        : iosIcon)
                    : (_viewModel.platformFlipped
                        ? iosIcon
                        : Icon(Icons.android)),
                onPressed: () {
                  _viewModel.platformFlipped = !_viewModel.platformFlipped;
                  _formKey.currentState.reset();
                },
              )
            ],
          ),
          body: new Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //shrinkWrap: true,
/*            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,*/
                controller: _scrollController,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Text(
                    'Tap the platform icon on the toolbar to simulate the other platform',
                    style: res.textStyleLabelSecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  XTextEditField(
                      key: _viewModel.keyMap["Name"],
                      fieldModel: new XFormFieldModel(
                        hintText: 'Your full name?',
                        labelText: 'Name *',
                        labelStyle: res.textStyleMenu,
                        hintStyle: res.textStyleHint,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (String value) {
                          _viewModel.name = value;
                        },
                        validator: _validateName,
                        focusNode: _focusNodeBy("Name"),
                        nextFocusNode: _focusNodeBy("Email"),
                      )),
                  const SizedBox(height: 24.0),
                  XTextEditField(
                      key: _viewModel.keyMap["Email"],
                      fieldModel: new XFormFieldModel(
                        labelText: 'E-mail *',
                        labelStyle: res.textStyleMenu,
                        hintText: 'Your e-mail address?',
                        hintStyle: res.textStyleHint,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String value) {
                          _viewModel.email = value;
                        },
                        validator: _validateEmail,
                        initialValue: "laszlo.galosi78@gmail.com",
                        focusNode: _focusNodeBy("Email"),
                        nextFocusNode: _focusNodeBy("Password"),
                      )),
                  const SizedBox(height: 24.0),
                  XPasswordField(
                      key: _viewModel.keyMap["Password"],
                      fieldModel: new XFormFieldModel(
                        labelText: 'Password *',
                        labelStyle: res.textStyleMenu,
                        hintText: '(min 8 characters one uppercase 1 number)',
                        hintStyle: res.textStyleLabelSecondary,
                        inputStyle: Platform.isAndroid
                            ? null
                            : res.textStyleLabelSecondary,
                        textInputAction: TextInputAction.next,
                        onSaved: (String value) {
                          _viewModel.password = value;
                        },
                        validator: _validatePassword,
                        focusNode: _focusNodeBy("Password"),
                        nextFocusNode: _focusNodeBy("PasswordConfirm"),
                      )),
                  const SizedBox(height: 24.0),
                  XPasswordField(
                      //We should supply a key for the TextFormField because
                      // of the keyboard disappearing bug at the last item in the list  .
                      // see: https://github.com/flutter/flutter/issues/15719
                      key: _viewModel.keyMap["PasswordConfirm"],
                      fieldModel: new XFormFieldModel(
                        labelText: 'Confirm password *',
                        labelStyle: res.textStyleMenu,
                        hintText: '(min 8 characters one uppercase 1 number)',
                        hintStyle: res.textStyleLabelSecondary,
                        inputStyle: Platform.isAndroid
                            ? null
                            : res.textStyleLabelSecondary,
                        validator: (val) {
                          final error = _validatePassword(val);
                          if (error == null &&
                              _viewModel
                                      .keyMap["Password"].currentState?.value !=
                                  val) {
                            return "Password and confirmation mismatch.";
                          }
                          return error;
                        },
                        focusNode: _focusNodeBy("PasswordConfirm"),
                        nextFocusNode: _focusNodeBy("Salary"),
                      )),
                  const SizedBox(height: 24.0),
                  XTextEditField(
                      key: _viewModel.keyMap["Phone"],
                      fieldModel: new XFormFieldModel(
                        labelText: 'Phone Number *',
                        labelStyle: res.textStyleMenu,
                        hintText: 'Your phone number?',
                        hintStyle: res.textStyleHint,
                        keyboardType: TextInputType.phone,
                        onSaved: (String value) {
                          _viewModel.phone = value;
                        },
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(12),
                          new WhitelistingTextInputFormatter(
                              new RegExp(r'[0-9+]+'))
                        ],
                        validator: (val) => val == null || val.isEmpty
                            ? "Phone number is required."
                            : null,
                        focusNode: _focusNodeBy("Phone"),
                        nextFocusNode: _focusNodeBy("Salary"),
                      )),
                  const SizedBox(height: 24.0),
                  XTextEditField(
                      key: _viewModel.keyMap["Salary"],
                      fieldModel: new XFormFieldModel(
                          labelText: 'Salary *',
                          labelStyle: res.textStyleMenu,
                          hintText: 'How much do you earn monthly?',
                          hintStyle: res.textStyleHint,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          onSaved: (String value) {
                            final formatter =
                                new NumberFormat("###,###.###", "hu-HU");
                            _viewModel.salary = formatter.parse(value).toInt();
                          },
                          inputFormatters: [new _AmountTextInputFormatter()],
                          focusedTextAlign: TextAlign.left,
                          unfocusedTextAlign: TextAlign.end,
                          validator: _validateAmount,
                          initialValue:
                              _AmountTextInputFormatter.format("150000"),
                          focusNode: _focusNodeBy("Salary"),
                          nextFocusNode: _focusNodeBy("About"),
                          suffix: Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                "HUF",
                                style: res.textStyleMenu,
                              )))),
                  const SizedBox(height: 24.0),
                  Opacity(
                      opacity: Platform.isIOS ||
                              (Platform.isAndroid && _viewModel.platformFlipped)
                          ? 1.0
                          : 0.0,
                      child:
                          Text('About yourself *', style: res.textStyleMenu)),
                  XTextEditField(
                      key: _viewModel.keyMap["About"],
                      fieldModel: new XFormFieldModel(
                          labelText: 'About yourself *',
                          prefix: Opacity(
                            opacity: 0.0,
                          ),
                          labelStyle: res.textStyleMenu,
                          hintText: 'Please write few words about yourself...',
                          hintStyle: res.textStyleHint,
//                          maxLines: 2,
                          keyboardType: TextInputType.text,
                          onSaved: (String value) {
                            _viewModel.about = value;
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? "Please, tell some few words about yourself"
                              : null,
                          focusNode: _focusNodeBy("About"),
                          textInputAction: TextInputAction.newline)),
                  const SizedBox(height: 24.0),
                  XDatePickerField(
                      key: _viewModel.keyMap["BirthDate"],
                      fieldModel: new XDatePickerFieldModel(
                          mode: CupertinoDatePickerMode.date,
                          labelText: "Date of birth",
                          hintText: "mm/dd/yyyy",
                          value: _viewModel.birthDate,
                          firstDate: new DateTime(1900),
                          lastDate: DateTime.now(),
                          initialDate: new DateTime(1980),
                          valueFormat: (val) => val == null
                              ? "mm/dd/yyyy"
                              : DateFormat.yMd().format(val),
                          valueStyle: (val) => val == null
                              ? res.textStylePicker.copyWith(color: Colors.grey)
                              : res.textStylePicker,
                          textAlign: TextAlign.start,
                          /*decoration: InputDecoration(
//                              hintStyle: textStyleLabel.copyWith(
//                                  color: Colors.black54),
//                              labelStyle: textStyleLabel,
                              labelText: "Date of birth",
                              hintText: "mm/dd/yyyy",
                              contentPadding: EdgeInsets.fromLTRB(9, 8, 9, 4),
                              errorMaxLines: 2,
                              hintMaxLines: 1,
//                              alignLabelWithHint: true,
                              errorStyle: textStyleError.copyWith(
                                  color: Colors.deepOrange, fontSize: 14.0),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent)),
                              fillColor: Colors.white70,
                              filled: true,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.indigoAccent))),*/
                          onDateTimeChanged: (date) =>
                              _viewModel.birthDate = date,
                          dateTimeValidator: (date) {
                            var error = date == null ||
                                    date == FormDemoViewModel.defaultBirthDate
                                ? "Birth date cannot be empty."
                                : null;
                            _logger.fine(
                                "validateBirthDate $date, ${_viewModel.birthDate} error: $error");
                            return error;
                          })),
                  const SizedBox(height: 24.0),
                  new XButton(
                      color: Colors.indigoAccent,
                      child: Text("Register", style: res.textStyleNormalDark),
                      onPressed: _handleSubmitted),
                  const SizedBox(height: 16.0),
                  Text(
                    '* indicates required field',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 24.0),
                ]),
          ));
    });
  }

  void showMessage(String message, [Color color = Colors.black]) {
    _viewModel.scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showMessage("Please fix the errors in red before submitting.");
      _logger.fine('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showMessage("Form validation success.");
      _logger.fine("Validation success. $_viewModel");
    }
  }

  String _validateName(String value) {
    _logger.shout("validateName '$value'");
    if (value == null || value.isEmpty) return 'Name is required.';
    final RegExp exp = RegExp(r'^[A-Za-z ]+$');
    _logger.fine("matches $exp: ${exp.hasMatch(value)}");
    if (!exp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateEmail(String value) {
    _logger.fine("validateEmail '$value'");
    if (value == null || value.isEmpty) return 'Email is required.';
    final RegExp exp = RegExp(EMAIL_PATTERN);
    _logger.fine("matches $exp: ${exp.hasMatch(value)}");
    if (!exp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  String _validatePassword(String value) {
    _logger.fine("validatePassword '$value'");
    if (value == null || value.isEmpty) return 'Password is required.';
    final RegExp exp =
        RegExp(r'^.*(?=.{6,})(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]+$');
    _logger.fine("matches $exp: ${exp.hasMatch(value)}");
    if (!exp.hasMatch(value))
      return 'Password must contain at least 6 characthers,  an upper case character and a number.';
    return null;
  }

  String _validateAmount(String value) {
    _logger.fine("validateAmount '$value'");
    if (value == null || value.isEmpty) return 'Salary is required.';
    final formatter = new NumberFormat("###,###.###", "hu-HU");
    try {
      if (formatter.parse(value) <= 0) {
        return "Salary must be greater than 0.";
      }
    } catch (FormatException) {
      _logger.fine("Parsing error: $FormatException");
      return "Invalid salary";
    }
    return null;
  }
}

// Format incoming numeric text to fit the format of hungarian amounts
class _AmountTextInputFormatter extends TextInputFormatter {
  static String format(String text) {
    // Do whatever you want
    final formatter = new NumberFormat("###,###.###", "hu-HU");
    return formatter.format(int.parse(text));
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    newValue = WhitelistingTextInputFormatter.digitsOnly
        .formatEditUpdate(oldValue, newValue);
    final int newTextLength = newValue.text.length;
    if (newTextLength == 0) {
      return newValue;
    }
    int usedSubstringIndex = 0;
    final value = int.parse(newValue.text);
    final formatter = new NumberFormat("###,###.###", "hu-HU");
    final newText = new StringBuffer();
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(formatter.format(value));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  static final WhitelistingTextInputFormatter _formatter =
      WhitelistingTextInputFormatter.digitsOnly;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    newValue = _formatter.formatEditUpdate(oldValue, newValue);
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _PhoneNumberInputFormatter extends TextInputFormatter {
  static final WhitelistingTextInputFormatter _formatter =
      WhitelistingTextInputFormatter.digitsOnly;
  static final Logger _logger = newLogger("_PhoneNumberInputFormatter");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    newValue = _formatter.formatEditUpdate(oldValue, newValue);
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    /*  if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }*/
    _logger.fine("newValue:'${newValue.text}', length=$newTextLength");
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ' ');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= 6) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 5) + ' ');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 10) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 9) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
