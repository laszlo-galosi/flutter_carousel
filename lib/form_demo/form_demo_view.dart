import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel/form_demo/form_demo_view_model.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive_form.dart';
import 'package:scoped_model/scoped_model.dart';

const String EMAIL_PATTERN =
    r"^[a-zóüöúőűáéíA-ZÓÜÖÚŐŰÁÉÍ00-9.!#\$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1," +
        "3}\\.[0-9]{1,3}\\" +
        ".[0-9]{1,3}])|(([a-zóüöúőűáéíA-ZÓÜÖÚŐŰÁÉÍ0\\-0-9]+\\.)+[a-zA-Z]{2,}))\$";

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

  bool _formWasEdited = false;

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
                        textInputAction: TextInputAction.done,
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
                        nextFocusNode: _focusNodeBy("Name"),
                      )),
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
      print('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showMessage("Form validation success.");
      print("Validation success. $_viewModel");
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    print("validateName '$value'");
    if (value == null || value.isEmpty) return 'Name is required.';
    final RegExp exp = RegExp(r'^[A-Za-z ]+$');
    print("matches $exp: ${exp.hasMatch(value)}");
    if (!exp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateEmail(String value) {
    _formWasEdited = true;
    print("validateEmail '$value'");
    if (value == null || value.isEmpty) return 'Email is required.';
    final RegExp exp = RegExp(EMAIL_PATTERN);
    print("matches $exp: ${exp.hasMatch(value)}");
    if (!exp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    print("validatePassword '$value'");
    if (value == null || value.isEmpty) return 'Password is required.';
    final RegExp exp =
        RegExp(r'^.*(?=.{6,})(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]+$');
    print("matches $exp: ${exp.hasMatch(value)}");
    if (!exp.hasMatch(value))
      return 'Password must contain at least 6 characthers,  an upper case character and a number.';
    return null;
  }
}
