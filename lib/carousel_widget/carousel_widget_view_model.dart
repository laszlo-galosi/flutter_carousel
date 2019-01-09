import 'package:flutter/material.dart';

// InheritedWidget subcla called ViewModelBinding because it connects the application’s widgets to the view model.
// InheritedWidgets keep track of their dependents, i.e. the BuildContexts from which the InheritedWidget was accessed.
// When an InheritedWidget is rebuilt, all of its dependents are rebuilt as well.
class _CarouselModelBindingWidget extends InheritedWidget {
  _CarouselModelBindingWidget({
    Key key,
    @required this.data,
    @required Widget child,
  })
      : assert(data != null),
        super(key: key, child: child);

  final CarouselWidgetState data;

  // Called when the ModelBinding is rebuilt. If it returns true,
  // then all of the dependent widgets are rebuilt.
  @override
  bool updateShouldNotify(_CarouselModelBindingWidget oldWidget) => true;
}

class CarouselWidget extends StatefulWidget {
  CarouselWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  CarouselWidgetState createState() => new CarouselWidgetState();

  static CarouselWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_CarouselModelBindingWidget)
    as _CarouselModelBindingWidget)
        .data;
  }
}

class CarouselWidgetState extends State<CarouselWidget> {
  bool _autoPlay = false;

  int _currentPage = 0;

  bool get autoPlay => _autoPlay;

  void setAutoPlay(bool autoPlay) {
    setState(() {
      _autoPlay = autoPlay;
    });
  }

  int get currentPage => _currentPage;

  void setCurrentPage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CarouselModelBindingWidget(
      data: this,
      child: widget.child,
    );
  }
}
