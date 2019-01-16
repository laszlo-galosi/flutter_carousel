import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;

class MainMenuWidget extends StatelessWidget {
  MainMenuWidget({Key key});

  @override
  Widget build(BuildContext context) {
    final state = SharedDrawer.of(context);
    final drawerControllerState = RootDrawer.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Demo"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              RootScaffold.openDrawer(context);
            },
          ),
        ),
        body: ListView(
            children: state
                .items()
                .where((item) => "Home" != item.title)
                .map<Widget>((item) {
          return new Container(
              padding: res.edgeInsetsItemH16V8,
              width: double.infinity,
              child: new Column(children: <Widget>[
                FlatButton(
                    color: Colors.indigoAccent,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: new Text(
                        item.title,
                        style: res.textStyleNormalDark,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () {
                      state.setSelectedItem(item);
                      if (state.navigator != null && item.routeName != null) {
                        state.setShouldGoBack(true);
                        state.navigator?.currentState
                            ?.pushNamed(item.routeName);
                        drawerControllerState?.close();
                      }
                    }),
                Text(item.description ?? "",
                    style: res.textStyleLabel, textAlign: TextAlign.center),
              ]));
        }).toList()));
  }
}
