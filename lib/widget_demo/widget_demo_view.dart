import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;

class WidgetDef extends StatelessWidget {
  WidgetDef({this.child, this.label, this.builder, this.isAndroid});

  final String label;
  final Widget child;
  final WidgetBuilder builder;
  final bool isAndroid;

  Widget build(BuildContext context) {
    if (builder != null) {
      assert(isAndroid != null,
          "WidgetDef Error: AdaptiveBuilder specified, but isAndroid not set");
      return builder(context);
    }
    assert(child != null,
        "WidgetDef Error: Either sepecify an AdaptiveBuilder or the child.");

    return Column(children: <Widget>[
      new Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: new Text(label ?? child.runtimeType.toString(),
              style: res.textStyleLabel)),
      child
    ]);
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
                    Tab(text: "Android"),
                    Tab(text: "iOS"),
                    Tab(text: "Adaptive"),
                  ],
                )),
            body: TabBarView(
              children: [
                new WidgetDemoTabPageWidget(
                  isAndroid: true,
                ),
                new WidgetDemoTabPageWidget(
                  isAndroid: false,
                ),
                new WidgetDemoTabPageWidget(
                    isAdaptive: true, isAndroid: !Platform.isIOS),
              ],
            )));
  }
}

class WidgetDemoTabPageWidget extends StatefulWidget {
  WidgetDemoTabPageWidget(
      {Key key, this.isAndroid = true, this.isAdaptive = false});

  final bool isAndroid;
  final bool isAdaptive;

  @override
  WidgetDemoTabPageState createState() =>
      new WidgetDemoTabPageState(isAndroid, isAdaptive);
}

class WidgetDemoTabPageState extends State<WidgetDemoTabPageWidget> {
  WidgetDemoTabPageState(this.isAndroid, this.isAdaptive);

  final bool isAndroid;
  final bool isAdaptive;
  bool _switchValue = false;
  bool _checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _widgetDefs(isAndroid, isAdaptive, this).length,
        itemBuilder: (BuildContext ctx, int index) {
          final widgetDef = _widgetDefs(isAndroid, isAdaptive, this)[index];
          return new DemoWidgetItem(child: widgetDef);
        });
  }

  List<WidgetDef> _widgetDefs(
      bool isAndroid, bool isAdaptive, WidgetDemoTabPageState state) {
    Map<String, Widget> widgetMap;
    if (isAdaptive)
      widgetMap = _adaptiveWidgets(state);
    else
      widgetMap = (isAndroid ? _androidWidgets(state) : _iosWidgets(state));
    return [
      new WidgetDef(
          isAndroid: isAndroid,
          builder: (context) {
            String label = "${widgetMap['Button'] == null ? "No ${isAdaptive ? 'adaptive' : ''} Button" : "${isAndroid ? "MaterialButton" : "CupertinoButton"}"}";
            return Column(children: <Widget>[
              new Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: new Text(
                      label,
                      style: res.textStyleLabel)),
              matchParent(widgetMap["Button"]),
            ]);
          }),
      new WidgetDef(
          isAndroid: isAndroid,
          builder: (context) {
            return Column(children: <Widget>[
              new Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: new Text(isAndroid ? "Switch ${isAdaptive? "(adaptive)" : ""}" : "CupertinoSwitch",
                      style: res.textStyleLabel)),
              Row(children: <Widget>[
                widgetMap["Switch"],
                Text(
                    "This is a ${isAndroid ? "Switch" : "CupertionSwitch"} swithed ${state._switchValue ? "on" : "off"}")
              ])
            ]);
          }),
      new WidgetDef(
          isAndroid: isAndroid,
          builder: (context) {
            String label = "${widgetMap['Checkbox'] == null ? "No ${isAdaptive ? 'adaptive' : ''} Checkbox" : "Checkbox"}";
            return Column(children: <Widget>[
              new Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: new Text(label, style: res.textStyleLabel)),
              Row(children: <Widget>[
                widgetMap["Checkbox"] ?? new Container(),
                (widgetMap["Checkbox"] != null ?Text(
                    "This is a Checkbox ${state._checkBoxValue ? "checked" : "unchecked"}")
                    : new Container())
              ])
            ]);
          }),
    ];
  }

  Map<String, Widget> _androidWidgets(WidgetDemoTabPageState state) => {
        "Button": new MaterialButton(
            color: Colors.indigoAccent,
            child: Text("Button", style: res.textStyleNormalDark),
            onPressed: () {}),
        "Switch": new Switch(
            value: state._switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              state.setState(() {
                state._switchValue = value;
              });
            }),
         "Checkbox": new Checkbox(
            value: state._checkBoxValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              state.setState(() {
                state._checkBoxValue = value;
              });
            }),
      };

  Map<String, Widget> _iosWidgets(WidgetDemoTabPageState state) => {
        "Button": new CupertinoButton(
            color: Colors.indigoAccent,
            child: Text("Button", style: res.textStyleNormalDark),
            onPressed: () {}),
        "Switch": new CupertinoSwitch(
            value: state._switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              state.setState(() {
                state._switchValue = value;
              });
            }),
        "Checkbox": new Checkbox(
            value: state._checkBoxValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              state.setState(() {
                state._checkBoxValue = value;
              });
            })
      };

  Map<String, Widget> _adaptiveWidgets(WidgetDemoTabPageState state) => {
        "Switch": new Switch.adaptive(
            value: state._switchValue,
            activeColor: Colors.indigoAccent,
            onChanged: (bool value) {
              state.setState(() {
                state._switchValue = value;
              });
            }),
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
      height: 120.0,
      decoration: new BoxDecoration(border: res.borderBottom1),
      child: child,
    );
  }
}
