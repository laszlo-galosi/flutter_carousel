import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive_form.dart';
import 'package:scoped_model/scoped_model.dart';

class FormDemoViewModel extends Model {
  FormDemoViewModel();

  final Map<String, GlobalKey<XTextEditFieldState>> _keyMap = Map.fromIterable(
      ["Name", "Email", "Password", "PasswordConfirm"],
      key: (name) => name,
      value: (name) => new GlobalKey<XTextEditFieldState>(debugLabel: name));

  Map<String, GlobalKey<XTextEditFieldState>> get keyMap => _keyMap;

  String _name;

  String get name => _name;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String _email;

  String get email => _email;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String _password;

  String get password => _password;

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _gender;

  String get gender => _gender;

  set gender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  bool _termsAccepted = false;

  bool get termsAccepted => _termsAccepted;

  set termsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  DateTime _birthDate = DateTime.now();

  DateTime get birthDate => _birthDate;

  set birthDate(DateTime dateTime) {
    _birthDate = dateTime;
    notifyListeners();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  set scaffoldKey(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
    notifyListeners();
  }

  bool _platformFlipped = XTextEditField.platformFlipped;

  bool get platformFlipped => _platformFlipped;

  set platformFlipped(bool flipped) {
    XTextEditField.platformFlipped = flipped;
    XStatelessWidget.platformFlipped = flipped;
    _platformFlipped = flipped;
    notifyListeners();
  }

  @override
  String toString() {
    return 'FormDemoViewModel{_name: $_name, _email: $_email, _password: $_password, _gender: $_gender, _termsAccepted: $_termsAccepted, _birthDate: $_birthDate}';
  }
}
