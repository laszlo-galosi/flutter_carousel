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
                new WidgetDemoTabPageWidget(
                  viewModel: new WidgetDemoTabViewModel(isAndroid: true),
                ),
                new WidgetDemoTabPageWidget(
                  viewModel: new WidgetDemoTabViewModel(isAndroid: false),
                ),
                new WidgetDemoTabPageWidget(
                    viewModel: new WidgetDemoTabViewModel(
                        isAdaptive: true, isAndroid: !Platform.isIOS)),
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
}

class WidgetDemoTabPageWidget extends StatefulWidget {
  WidgetDemoTabPageWidget({Key key, @required this.viewModel});

  final WidgetDemoTabViewModel viewModel;

  @override
  WidgetDemoTabPageState createState() => new WidgetDemoTabPageState();
}

class WidgetDemoTabPageState extends State<WidgetDemoTabPageWidget> {
  WidgetDemoTabPageState({Key key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<WidgetDemoTabViewModel>(
        model: widget.viewModel,
        child: new ListView.builder(
            itemCount: _widgetDefs(context).length,
            itemBuilder: (BuildContext ctx, int index) {
              final widgetDef = _widgetDefs(context)[index];
              return new DemoWidgetItem(child: widgetDef);
            }));
  }

  List<WidgetDef> _widgetDefs(BuildContext context) {
    Map<String, Widget> widgetMap = getWidgetMap(context);
    return [
      _buildWidgetDef("DatePicker", context,
          label: "${widgetMap["DatePicker"].runtimeType}",
          children: [widgetMap["DatePicker"]]),
      _buildWidgetDef("DateTimePicker", context,
          label: "${widgetMap["DateTimePicker"].runtimeType}",
          children: [widgetMap["DateTimePicker"]]),
      new WidgetDef(builder: (context) {
        String label =
            "${widgetMap['Button'] == null ? "No ${widget.viewModel.isAdaptive ? 'adaptive' : ''} Button" : "${widget.viewModel.isAndroid ? "MaterialButton" : "CupertinoButton"}"}";
        return Column(children: <Widget>[
          new Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: new Text(label, style: res.textStyleLabel)),
          matchParent(widgetMap["Button"]),
        ]);
      }),
      _buildWidgetDef("Switch", context,
          label: widget.viewModel.isAndroid ? "Switch" : "CupertinoSwitch",
          children: <Widget>[
            widgetMap["Switch"],
            Text(
                "This is a ${widget.viewModel.isAndroid ? "Switch" : "CupertionSwitch"} swithed ${widget.viewModel.switchValue ? "on" : "off"}")
          ]),
      _buildWidgetDef("Checkbox", context,
          label: "Checkbox",
          children: <Widget>[
            widgetMap["Checkbox"] ?? new Container(),
            (widgetMap["Checkbox"] != null
                ? Text(
                    "This is a Checkbox ${widget.viewModel.checkBoxValue ? "checked" : "unchecked"}")
                : new Container())
          ]),
    ];
  }

  WidgetDef _buildWidgetDef(String key, BuildContext context,
      {String label, @required List<Widget> children}) {
    Map<String, Widget> widgetMap = getWidgetMap(context);
    return new WidgetDef(builder: (context) {
      String labelText =
          "${widgetMap[key] == null ? "No ${widget.viewModel.isAdaptive ? 'adaptive' : ''} $key" : label}";
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
    Map<String, Widget> widgetMap = widget.viewModel.isAdaptive
        ? _adaptiveWidgets()
        : (widget.viewModel.isAndroid
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
            value: widget.viewModel.switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => widget.viewModel.switchValue = value),
        "Checkbox": new Checkbox(
            value: widget.viewModel.checkBoxValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => widget.viewModel.checkBoxValue = value),
        "DatePicker": new MaterialDateTimePicker(
            label: "Date",
            valueDate: widget.viewModel.dateTime,
            formatter: (date) => DateFormat.yMMMMd().format(date),
            onDateChanged: (date) => widget.viewModel.dateTime = date),
        "DateTimePicker": new MaterialDateTimePicker(
            label: "Date and Time",
            valueDate: widget.viewModel.dateTime,
            valueTime: TimeOfDay.fromDateTime(widget.viewModel.dateTime),
            formatter: (value) {
              if (value is DateTime) return DateFormat.yMMMd().format(value);
              return value.format(context); //use default formatter.
            },
            onDateChanged: (date) => widget.viewModel.dateTime = date,
            onTimeChanged: (time) {
              final d = widget.viewModel._dateTime;
              widget.viewModel.dateTime =
                  new DateTime(d.year, d.month, d.day, time.hour, time.minute);
            }),
      };

  Map<String, Widget> _cupertinoWidgets() => {
        "Button": new CupertinoButton(
            color: Colors.indigoAccent,
            child: Text("Button", style: res.textStyleNormalDark),
            onPressed: () {}),
        "Switch": new CupertinoSwitch(
            value: widget.viewModel.switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => widget.viewModel.switchValue = value),
        "Checkbox": new Checkbox(
            value: widget.viewModel.checkBoxValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => widget.viewModel.checkBoxValue = value),
        "DatePicker": CupertinoDateTimePicker(
            mode: CupertinoDatePickerMode.date,
            value: widget.viewModel.dateTime,
            label: "Date",
            formatter: (date) => DateFormat.yMMMMd().format(date),
            onDateTimeChanged: (date) => widget.viewModel.dateTime = date),
        "DateTimePicker": CupertinoDateTimePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            value: widget.viewModel.dateTime,
            label: "Date and Time",
            formatter: (date) => DateFormat.yMMMd().add_jm().format(date),
            onDateTimeChanged: (date) => widget.viewModel.dateTime = date),
      };

  Map<String, Widget> _adaptiveWidgets() => {
        "Switch": new Switch.adaptive(
            value: widget.viewModel.switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) => widget.viewModel.switchValue = value),
      };
}

class DemoWidgetItem extends StatelessWidget {
  DemoWidgetItem({Key key, @required this.child, this.isAndroid = true});

  final bool isAndroid;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: double.infinity,
      height: 140.0,
      decoration: new BoxDecoration(border: res.borderBottom1),
      child: child,
    );
  }
}
