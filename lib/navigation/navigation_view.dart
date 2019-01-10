import 'package:flutter/material.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key key});

  @override
  Widget build(BuildContext context) {
    final rootDrawerState = RootDrawer.of(context);
    final state = SharedDrawer.of(context);
//    state.setDrawerControllerState(rootDrawerState);
    return Drawer(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.itemCount + 1,
            itemBuilder: (BuildContext ctx, int index) {
              NavigationItem item = state.getItemAt(index - 1);
              if (index == 0)
                return _drawerHeader;
              else
                return new ListTile(
                  title: new Text(item?.title ?? "Title is null.",
                      style: res.textStyleMenu),
                  leading: Icon(item?.icon ?? null),
                  onTap: () {
                    state.setSelectedItemIndex(index - 1);
                    if (item.navigationCallback != null &&
                        state.navigator != null) {
                      item.navigationCallback(state, rootDrawerState);
                    }
                  },
                );
            }));
  }

  final Widget _drawerHeader = DrawerHeader(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      child: Row(children: <Widget>[
        FlutterLogo(size: 48.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("Flutter Demo", style: res.textStyleTitleDark),
        ),
      ]),
      height: 100.0,
    ),
    decoration: new BoxDecoration(color: Colors.indigo),
  );
}
