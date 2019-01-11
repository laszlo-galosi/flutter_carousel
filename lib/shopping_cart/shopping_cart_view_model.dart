import 'package:flutter/material.dart';

class ShoppingItem {
  String reference;

  ShoppingItem(this.reference);
}

class _ShoppingCartModelBindingWidget extends InheritedWidget {
  _ShoppingCartModelBindingWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final ShoppingCartWidgetState data;

  @override
  bool updateShouldNotify(_ShoppingCartModelBindingWidget oldWidget) {
    return true;
  }
}

class ShoppingCartWidget extends StatefulWidget {
  ShoppingCartWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ShoppingCartWidgetState createState() => new ShoppingCartWidgetState();

  static ShoppingCartWidgetState of(
      [BuildContext context, bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(
                    _ShoppingCartModelBindingWidget)
                as _ShoppingCartModelBindingWidget
            : context.ancestorWidgetOfExactType(_ShoppingCartModelBindingWidget)
                as _ShoppingCartModelBindingWidget)
        .data;
  }
}

class ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  /// List of Items
  List<ShoppingItem> _items = <ShoppingItem>[];

  /// Getter (number of items)
  int get itemsCount => _items.length;

  /// Helper method to add an Item
  void addItem(String reference) {
    setState(() {
      _items.add(new ShoppingItem(reference));
    });
  }

  ShoppingItem getItemAt(int index) {
    if (index >= 0 && index < _items.length) return _items[index];
    return null;
  }

  void removeItemAt(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  List<ShoppingItem> items() => _items;

  @override
  Widget build(BuildContext context) {
    return new _ShoppingCartModelBindingWidget(
      data: this,
      child: widget.child,
    );
  }
}
