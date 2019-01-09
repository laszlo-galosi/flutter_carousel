import 'package:flutter/material.dart';
import 'package:flutter_carousel/carousel_widget/carousel_widget_view.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/shopping_cart/shopping_cart_view.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key, this.title});

  final String title;

  List<String> _menuNames = ["Header", "Carousel", "Shopping"];

  Map<String, String> _menuDescriptions = {
    "Carousel": "Carousel Widget with current page indicator.",
    "Shopping":
    "Shopping Cart demo showcasing Flutter's StatefulWidget - InheritedWidget concept."
  };

  factory HomePageView.forDesignTime() {
    return new HomePageView(title: "Flutter Demo");
  }

  Widget _drawerHeader = DrawerHeader(
    child: Container(
      child: Row(children: <Widget>[
        FlutterLogo(size: 48.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text("Flutter Demo", style: res.textStyleTitleDark),
        ),
      ]),
      height: 100.0,
    ),
    decoration: new BoxDecoration(color: Colors.indigo),
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was createdP bPy
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _menuNames.map((item) {
                ListTile listTile;
                switch (item) {
                  case "Header":
                    return _drawerHeader;
                  case "Carousel":
                    listTile = new ListTile(
                      title: new Text(item, style: res.textStyleMenu),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (ctx) => new CarouselPageWidget()));
                      },
                    );
                    continue hasListTile;
                  case "Shopping":
                    listTile = new ListTile(
                      title: new Text(item, style: res.textStyleMenu),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (ctx) => new ShoppingPageWidget()));
                      },
                    );
                    continue hasListTile;
                  hasListTile:
                  case "hasListTile":
                    return listTile;
                /*return new Container(
                    child: listTile,
                    width: double.infinity,
                    padding: res.edgeInsetsItemH16V8,
                  );*/
                  default:
                    return Container(
                      child: new Text(item, style: res.textStyleNormal),
                      width: double.infinity,
                      padding: res.edgeInsetsItemH16V8,
                    );
                }
              }).toList(),
            )),
        body: ListView(
            children: _menuNames.where((name) {
              return "Header" != name;
            }).map<Widget>((item) {
              return new Container(
                  padding: res.edgeInsetsItemH16V8,
                  width: double.infinity,
                  child: new Column(children: <Widget>[
                    new RaisedButton(
                        child: Container(
                          width: double.infinity,
                          child: new Text(
                            item,
                            style: res.textStyleTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onPressed: () {
                          Widget page;
                          switch (item) {
                            case "Carousel":
                              page = new CarouselPageWidget();
                              break;
                            case "Shopping":
                              page = new ShoppingPageWidget();
                              break;
                          }
                          if (page != null) {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (ctx) => page));
                          }
                        }),
                    Text(_menuDescriptions[item] ?? "",
                        style: res.textStyleLabel, textAlign: TextAlign.center),
                  ]));
            }).toList()));
  }
}
