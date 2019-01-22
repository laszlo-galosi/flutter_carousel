import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/widget_pickers_cupertino.dart';
import 'package:flutter_carousel/widget_demo/widget_pickers_material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

const Map<String, Color> coolColors = {
  "Indigo": Colors.indigo,
  "White": Colors.white,
  "Black": Colors.black,
  "Red": Colors.red,
  "Green": Colors.green,
  "Blue": Colors.blue,
  "Orange": Colors.orange,
  "Yellow": Colors.yellow,
  "Purple": Colors.purple,
  "Cyan": Colors.cyan,
  "Lime": Colors.lime,
};

class WidgetDef extends StatelessWidget {
  WidgetDef({this.child, this.label, this.builder});

  final String label;
  final Widget child;
  final WidgetBuilder builder;

  Widget build(BuildContext context) {
    return new ScopedModelDescendant<WidgetDemoTabViewModel>(
        builder: (context, _, model) {
      if (builder != null) {
        assert(model.isAndroid != null,
            "WidgetDef Error: AdaptiveBuilder specified, but isAndroid not set");
        return builder(context);
      }
      assert(child != null,
          "WidgetDef Error: Either sepecify an AdaptiveBuilder or the child.");
      return new Column(children: <Widget>[
        new Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: new Text(label ?? child.runtimeType.toString(),
                style: res.textStyleLabel)),
        child
      ]);
    });
  }
}

class WidgetDemoPageWidget extends StatefulWidget {
  WidgetDemoPageWidget();

  factory WidgetDemoPageWidget.forDesignTime() {
    return new WidgetDemoPageWidget();
  }

  @override
  _WidgetDemoPageWidgetState createState() => new _WidgetDemoPageWidgetState();
}

class _WidgetDemoPageWidgetState extends State<WidgetDemoPageWidget> {
  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
            appBar: AppBar(
                title: Text(navState.selectedItem?.title ?? "",
                    style: res.textStyleTitleDark),
                leading: IconButton(
                  icon: Icon(navState.shouldGoBack
                      ? res.backIcon(context)
                      : Icons.menu),
                  onPressed: () {
                    if (navState.shouldGoBack) {
                      navState.navigator.currentState.pop();
                    } else {
                      RootScaffold.openDrawer(context);
                    }
                  },
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: "Material"),
                    Tab(text: "Cupertino"),
                    Tab(text: "Adaptive"),
                  ],
                )),
            body: TabBarView(
              children: [
                new ScopedModel<WidgetDemoTabViewModel>(
                  model: new WidgetDemoTabViewModel(isAndroid: true),
                  child: new WidgetDemoTabPageWidget(),
                ),
                new ScopedModel<WidgetDemoTabViewModel>(
                  model: new WidgetDemoTabViewModel(isAndroid: false),
                  child: new WidgetDemoTabPageWidget(),
                ),
                new ScopedModel<WidgetDemoTabViewModel>(
                    model: new WidgetDemoTabViewModel(
                        isAdaptive: true, isAndroid: !Platform.isIOS),
                    child: new WidgetDemoTabPageWidget()),
              ],
            )));
  }
}

class WidgetDemoTabViewModel extends Model {
  WidgetDemoTabViewModel({
    this.isAndroid = true,
    this.isAdaptive = false,
  });

  final bool isAndroid;
  final bool isAdaptive;

  bool _switchValue = false;

  bool get switchValue => _switchValue;

  set switchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }

  bool _checkBoxValue = false;

  bool get checkBoxValue => _checkBoxValue;

  set checkBoxValue(bool value) {
    _checkBoxValue = value;
    notifyListeners();
  }

  DateTime _dateTime = DateTime.now();

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }

  Color _color = Colors.indigo;

  Color get color => _color;

  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  @override
  String toString() {
    return 'WidgetDemoTabViewModel{isAndroid: $isAndroid, isAdaptive: $isAdaptive, _switchValue: $_switchValue, _checkBoxValue: $_checkBoxValue, _dateTime: $_dateTime}';
  }
}

class WidgetDemoTabPageWidget extends StatelessWidget {
  WidgetDemoTabPageWidget({Key key});

  WidgetDemoTabViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<WidgetDemoTabViewModel>(
        builder: (context, _, model) {
      _viewModel = model;
      return new ListView.builder(
          itemCount: _widgetDefs(context).length,
          itemBuilder: (BuildContext ctx, int index) {
            final widgetDef = _widgetDefs(context)[index];
            return new DemoWidgetItem(child: widgetDef);
          });
    });
  }

  List<WidgetDef> _widgetDefs(BuildContext context) {
    Map<String, Widget> widgetMap = getWidgetMap(context);
    return [
      _buildWidgetDef("Picker", context,
          label: "${widgetMap["Picker"].runtimeType}",
          children: [widgetMap["Picker"]]),
      _buildWidgetDef("DatePicker", context,
          label: "${widgetMap["DatePicker"].runtimeType}",
          children: [widgetMap["DatePicker"]]),
      _buildWidgetDef("DateTimePicker", context,
          label: "${widgetMap["DateTimePicker"].runtimeType}",
          children: [widgetMap["DateTimePicker"]]),
      new WidgetDef(builder: (context) {
        String label =
            "${widgetMap['Button'] == null ? "No ${_viewModel.isAdaptive ? 'adaptive' : ''} Button" : "${_viewModel.isAndroid ? "MaterialButton" : "CupertinoButton"}"}";
        return Column(children: <Widget>[
          new Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: new Text(label, style: res.textStyleLabel)),
          matchParent(widgetMap["Button"]),
        ]);
      }),
      _buildWidgetDef("Switch", context,
          label: _viewModel.isAndroid ? "Switch" : "CupertinoSwitch",
          children: <Widget>[
            widgetMap["Switch"],
            Text(
                "This is a ${_viewModel.isAndroid ? "Switch" : "CupertionSwitch"} swithed ${_viewModel.switchValue ? "on" : "off"}")
          ]),
      _buildWidgetDef("Checkbox", context,
          label: "Checkbox",
          children: <Widget>[
            widgetMap["Checkbox"] ?? new Container(),
            (widgetMap["Checkbox"] != null
                ? Text(
                    "This is a Checkbox ${_viewModel.checkBoxValue ? "checked" : "unchecked"}")
                : new Container())
          ]),
    ];
  }

  WidgetDef _buildWidgetDef(String key, BuildContext context,
      {String label, @required List<Widget> children}) {
    Map<String, Widget> widgetMap = getWidgetMap(context);
    return new WidgetDef(builder: (context) {
      String labelText =
          "${widgetMap[key] == null ? "No ${_viewModel.isAdaptive ? 'adaptive' : ''} $key" : label}";
      return Column(children: <Widget>[
        new Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: new Text(labelText, style: res.textStyleLabel)),
        children.length > 1
            ? Row(children: children)
            : Container(child: children[0]),
      ]);
    });
  }

  Map<String, Widget> getWidgetMap(BuildContext context) {
    Map<String, Widget> widgetMap = _viewModel.isAdaptive
        ? _adaptiveWidgets()
        : (_viewModel.isAndroid
            ? _materialWidgets(context)
            : _cupertinoWidgets());
    return widgetMap;
  }

  Map<String, Widget> _materialWidgets(BuildContext context) => {
        "Button": new MaterialButton(
            color: Colors.indigoAccent,
            child: Text("Button", style: res.textStyleNormalDark),
            onPressed: () {}),
        "Switch": new Switch(
            value: _viewModel.switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => _viewModel.switchValue = value),
        "Checkbox": new Checkbox(
            value: _viewModel.checkBoxValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              print("onChanegd: ${_viewModel}");
              _viewModel.checkBoxValue = value;
            }),
        "DatePicker": new MaterialDateTimePicker(
            label: "Date",
            valueDate: _viewModel.dateTime,
            formatter: (date) => DateFormat.yMMMMd().format(date),
            onDateChanged: (date) => _viewModel.dateTime = date),
        "DateTimePicker": new MaterialDateTimePicker(
            label: "Date and Time",
            valueDate: _viewModel.dateTime,
            valueTime: TimeOfDay.fromDateTime(_viewModel.dateTime),
            formatter: (value) {
              if (value is DateTime) return DateFormat.yMMMd().format(value);
              return value.format(context); //use default formatter.
            },
            onDateChanged: (date) => _viewModel.dateTime = date,
            onTimeChanged: (time) {
              final d = _viewModel._dateTime;
              _viewModel.dateTime =
                  new DateTime(d.year, d.month, d.day, time.hour, time.minute);
            }),
        "Picker": MaterialPickerWidget(
            value: _viewModel._color,
            label: "Pick a color",
            itemBuilder: (context) {
              return coolColors.keys.map((key) {
                Color col = coolColors[key];
                return DropdownMenuItem<Color>(
                    value: col,
                    child: Row(children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: Container(
                              decoration: BoxDecoration(color: col),
                            )),
                      ),
                      Text(key, style: res.textStylePicker),
                    ]));
              }).toList();
            },
            formatter: (value) {
              return colorNames()[value] ?? value.toString();
            },
            onSelectedItemChanged: (value) => _viewModel.color = value),
      };

  Map<String, Widget> _cupertinoWidgets() => {
        "Button": new CupertinoButton(
            color: Colors.indigoAccent,
            child: Text("Button", style: res.textStyleNormalDark),
            onPressed: () {}),
        "Switch": new CupertinoSwitch(
            value: _viewModel.switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => _viewModel.switchValue = value),
        "Checkbox": new Checkbox(
            value: _viewModel.checkBoxValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              print("onChanegd: ${_viewModel} to $value");
              _viewModel.checkBoxValue = value;
            }),
        "DatePicker": CupertinoDateTimePicker(
            mode: CupertinoDatePickerMode.date,
            value: _viewModel.dateTime,
            label: "Date",
            formatter: (date) => DateFormat.yMMMMd().format(date),
            onDateTimeChanged: (date) => _viewModel.dateTime = date),
        "DateTimePicker": CupertinoDateTimePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            value: _viewModel.dateTime,
            label: "Date and Time",
            formatter: (date) => DateFormat.yMMMd().add_jm().format(date),
            onDateTimeChanged: (date) => _viewModel.dateTime = date),
        "Picker": CupertinoPickerWidget(
            value: _viewModel.color,
            label: "Pick a color",
            itemBuilder: (context) {
              return coolColors.keys.map((key) {
                Color col = coolColors[key];
                return Container(
                    child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(color: col),
                        )),
                  ),
                  Text(key, style: res.textStyleNormal),
                ]));
              }).toList();
            },
            formatter: (value) {
              print("selected: $value");
              return colorNames()[value] ?? value.toString();
            },
            indexMapper: (index) => coolColors.values.toList()[index],
            onSelectedItemChanged: (value) => _viewModel.color = value),
      };

  Map<String, Widget> _adaptiveWidgets() => {
        "Switch": new Switch.adaptive(
            value: _viewModel.switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => _viewModel.switchValue = value),
      };

  Map<Color, String> colorNames() => coolColors.map((k, v) => MapEntry(v, k));
}

class DemoWidgetItem extends StatelessWidget {
  DemoWidgetItem({Key key, @required this.child, this.isAndroid = true});

  final bool isAndroid;
  final Widget child;

  @override
  Widget build(BuildContext context) {
/*    return new Padding(
      padding:
          const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: new Card(
          child: new Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: child)),
    );*/
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: 140.0,
            child: child));
  }
}
