import 'package:flutter/material.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;

import './shopping_cart_view_model.dart';

class ShoppingPageWidget extends StatefulWidget {
  ShoppingPageWidget();

  factory ShoppingPageWidget.forDesignTime() {
    return new ShoppingPageWidget();
  }

  @override
  _ShoppingPageWidgetState createState() => new _ShoppingPageWidgetState();
}

class _ShoppingPageWidgetState extends State<ShoppingPageWidget> {
  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return new ShoppingCartWidget(
        child: new Scaffold(
            appBar: AppBar(
              title: Text(navState.selectedItem?.title ?? "",
                  style: res.textStyleTitleDark),
              leading: IconButton(
                icon:
                Icon(navState.shouldGoBack ? Icons.arrow_back : Icons.menu),
                onPressed: () {
                  if (navState.shouldGoBack) {
                    navState.navigator.currentState.pop();
                  } else {
                    RootScaffold.openDrawer(context);
                  }
                },
              ),
            ),
            body: new ShoppingCartListWidget(),
            floatingActionButton: AddShoppingItemButton()));
  }
}

class ShoppingCartListWidget extends StatelessWidget {
  ShoppingCartListWidget({Key key});

  @override
  Widget build(BuildContext context) {
    final ShoppingCartWidgetState state = ShoppingCartWidget.of(context);
    return new ListView.builder(
        itemCount: state.itemsCount + 2,
        itemBuilder: (BuildContext ctx, int index) {
          switch (index) {
            case 0:
              return Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: new Text(
                    "Press '+' to place an item in the shopping cart.",
                    style: res.textStyleLabel,
                    textAlign: TextAlign.center,
                  ));
            case 1:
              return new ShoppingCartSummaryWidget();
            default:
              return new ShoppingItemWidget(itemIndex: index - 2);
          }
        });
  }
}

class AddShoppingItemButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShoppingCartWidgetState state = ShoppingCartWidget.of(context, false);
    return new FloatingActionButton(
        tooltip: "Add Item",
        child: Icon(Icons.add),
        onPressed: () {
          state.addItem("Item ${state.itemsCount}");
        });
  }
}

class ShoppingCartSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShoppingCartWidgetState state = ShoppingCartWidget.of(context);
    return new Container(
        padding: res.edgeInsetsItemH16V8,
        width: double.infinity,
        child: new Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: new Icon(Icons.shopping_cart),
          ),
          new Text('Items: ${state.itemsCount}', style: res.textStyleNormal),
        ]));
  }
}

class ShoppingItemWidget extends StatelessWidget {
  final int itemIndex;

  ShoppingItemWidget({Key key, this.itemIndex});

  @override
  Widget build(BuildContext context) {
    final ShoppingCartWidgetState state = ShoppingCartWidget.of(context);
    return Container(
        padding: res.edgeInsetsItemH16V8,
        width: double.infinity,
        decoration: new BoxDecoration(border: res.borderBottom1),
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(Icons.image, color: Colors.black26),
          ),
          new Expanded(
              child: new Text(
                  state.getItemAt(itemIndex)?.reference ?? "Not found",
                  style: res.textStyleNormal),
              flex: 10),
          new Expanded(
              child: new IconButton(
                icon: new Icon(Icons.delete, color: Colors.black54),
                onPressed: () {
                  state.removeItemAt(itemIndex);
                },
              ),
              flex: 1),
        ]));
  }
}
