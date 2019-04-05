import 'package:flutter/material.dart';

typedef NavigationCallback = void Function(
    SharedDrawerState drawerState, DrawerControllerState controllerState);

final List<NavigationItem> navigationMenuItems = [
  new NavigationItem(
      title: "Home",
      routeName: "/",
      icon: Icon(Icons.home),
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState?.pushReplacementNamed("/");
        controller.close();
      }),
  new NavigationItem(
      title: "Web Demo",
      description: "Demonstrates WebViews and Html widget",
      routeName: "/webdemo",
      icon: Icon(Icons.web),
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState?.pushReplacementNamed("/webdemo");
        controller.close();
      }),
  new NavigationItem(
      title: "Form Demo",
      description:
          "Input form demo, showcasing various input widgets and its functionality.",
      routeName: "/form_demo",
      icon: Icon(Icons.receipt),
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState?.pushReplacementNamed("/form_demo");
        controller.close();
      }),
  new NavigationItem(
      title: "Widget Demo",
      routeName: "/widget_demo",
      icon: Icon(Icons.widgets),
      description:
          "Material and Cupertino Widget demo to showcase differences of the platforms.",
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState
            ?.pushReplacementNamed("/widget_demo");
        controller.close();
      }),
  new NavigationItem(
      title: "Infinite List Demo",
      routeName: "/infinite_list",
      icon: Icon(Icons.list),
      description:
          "Infinite paging list demo, calling a Rest Api with paged results.",
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState
            ?.pushReplacementNamed("/infinite_list");
        controller.close();
      }),
  new NavigationItem(
      title: "Scratch Demo",
      routeName: "/scratch",
      icon: new Image.asset(
        'images/ic_scratch.png',
        width: 24.0,
        color: Colors.black38,
      ),
      description: "Scratch view demo.",
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState?.pushReplacementNamed("/scratch");
        controller.close();
      }),
  new NavigationItem(
      title: "Carousel Demo",
      routeName: "/carousel",
      icon: Icon(Icons.widgets),
      description: "Carousel Widget with current page indicator.",
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState?.pushReplacementNamed("/carousel");
        controller.close();
      }),
  new NavigationItem(
      title: "Shopping Cart",
      routeName: "/shopping",
      icon: Icon(Icons.shopping_cart),
      description:
          "Shopping Cart demo showcasing Flutter's StatefulWidget - InheritedWidget concept.",
      navigationCallback: (drawerState, controller) {
        drawerState.setShouldGoBack(false);
        drawerState.navigator?.currentState?.pushReplacementNamed("/shopping");
        controller.close();
      }),
];

class NavigationItem {
  final String title;
  final String routeName;
  final Widget icon;
  final String description;
  final NavigationCallback navigationCallback;

  NavigationItem(
      {@required this.title,
      this.routeName,
      this.icon,
      this.description,
      this.navigationCallback});
}

class _SharedDrawerBindingWidget extends InheritedWidget {
  _SharedDrawerBindingWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final SharedDrawerState data;

  @override
  bool updateShouldNotify(_SharedDrawerBindingWidget oldWidget) {
    return true;
  }
}

class SharedDrawer extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final GlobalKey<NavigatorState> rootDrawerState;

  SharedDrawer(
      {Key key,
      @required this.child,
      @required this.navigator,
      this.rootDrawerState})
      : super(key: key);

  final Widget child;

  @override
  SharedDrawerState createState() => SharedDrawerState(navigator: navigator);

  static SharedDrawerState of([BuildContext context, bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_SharedDrawerBindingWidget)
                as _SharedDrawerBindingWidget
            : context.ancestorWidgetOfExactType(_SharedDrawerBindingWidget)
                as _SharedDrawerBindingWidget)
        .data;
  }
}

class SharedDrawerState extends State<SharedDrawer> {
  SharedDrawerState({@required this.navigator});

  GlobalKey<NavigatorState> navigator;

  DrawerControllerState _drawerControllerState;

  DrawerControllerState get drawerControllerState => _drawerControllerState;

  void setDrawerControllerState(DrawerControllerState state) {
    setState(() {
      _drawerControllerState = state;
    });
  }

  List<NavigationItem> _items = navigationMenuItems;

  List<NavigationItem> items() => _items;

  int _selectedItemIndex = 0;

  /// Getter (number of items)
  int get itemCount => _items.length;

  int get selectedItemIndex => _selectedItemIndex;

  void setSelectedItemIndex(int index) {
    if (index < 0 || index >= itemCount) return;
    setState(() {
      _selectedItemIndex = index;
    });
  }

  bool _shouldGoBack = false;

  bool get shouldGoBack => _shouldGoBack;

  void setShouldGoBack(bool goBack) {
    setState(() {
      _shouldGoBack = goBack;
    });
  }

  void setSelectedItem(NavigationItem item) {
    int index = _items.indexOf(item);
    setSelectedItemIndex(index);
  }

  /// Helper method to add an Item
  void addItem(int id, [String title, Widget icon]) {
    setState(() {
      _items.add(new NavigationItem(title: title, icon: icon));
    });
  }

  void setItems(List<NavigationItem> items) {
    setState(() {
      _items.clear();
      _items.addAll(items);
    });
  }

  NavigationItem getItemAt(int index) {
    if (index >= 0 && index < _items.length) return _items[index];
    return null;
  }

  NavigationItem get selectedItem => getItemAt(_selectedItemIndex);

  void removeItemAt(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _SharedDrawerBindingWidget(
      data: this,
      child: widget.child,
    );
  }
}

class RootDrawer {
  static DrawerControllerState of(BuildContext context) {
    final DrawerControllerState drawerControllerState =
        context.rootAncestorStateOfType(TypeMatcher<DrawerControllerState>());
    return drawerControllerState;
  }
}

class RootScaffold {
  static openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    scaffoldState.openDrawer();
  }

  static ScaffoldState of(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    return scaffoldState;
  }
}
