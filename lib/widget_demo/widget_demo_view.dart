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

List<WidgetDef> widgetDef(bool isAndroid) {
  List<WidgetDef> result = [];
  return result;
}

List<WidgetDef> widgetDefs(bool isAndroid) {
  Map<String, Widget> widgetMap = (isAndroid ? _androidWidgets : _iosWidgets);
  return [
    WidgetDef(
        isAndroid: isAndroid,
        builder: (context) {
          return Column(children: <Widget>[
            new Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: new Text(
                    isAndroid ? "MaterialButton" : "CupertinoButton",
                    style: res.textStyleLabel)),
            matchParent(widgetMap["Button"]),
          ]);
        }),
    new WidgetDef(child: widgetMap["Switch"]),
  ];
}

Map<String, Widget> _androidWidgets = {
  "Button": new MaterialButton(
      color: Colors.indigoAccent,
      child: Text("Button", style: res.textStyleNormalDark),
      onPressed: () {}),
  "Switch": Switch(
      value: false,
      activeColor: Colors.indigoAccent,
      onChanged: (bool value) {}),
};

class DemoWidget extends StatefulWidget {
  DemoWidget({Key key, @required this.child});
  final Widget child;

  @override
  DemoWidgetState createState() => new DemoWidgetState();
}

class DemoWidgetState extends State<DemoWidget> {
  DemoWidgetState({Key key, @required this.child});
  final Widget child;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

Map<String, Widget> _iosWidgets = {
  "Button": new CupertinoButton(
      color: Colors.indigoAccent,
      child: Text("Button", style: res.textStyleNormalDark),
      onPressed: () {}),
  "Switch": CupertinoSwitch(
    value: true,
    activeColor: Colors.indigoAccent,
  ),
};

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
        length: 2,
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
              ],
            )));
  }
}

class WidgetDemoTabPageWidget extends StatelessWidget {
  WidgetDemoTabPageWidget({Key key, this.isAndroid = true});

  final bool isAndroid;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widgetDefs(isAndroid).length,
        itemBuilder: (BuildContext ctx, int index) {
          final widgetDef = widgetDefs(isAndroid)[index];
          return new DemoWidgetItem(child: widgetDef);
        });
  }
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
      decoration: new BoxDecoration(border: res.borderBottom1),
      child: child,
    );
  }
}
