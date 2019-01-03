import 'package:flutter/material.dart';

class CarouselWidgetViewModel {
  // true if the CarouselSlider should automatically scroll the pages.
  //see CarouselSlider.
  final bool autoPlay;

  // property to store the currently visible page index of the Carousel
  final int currentPage;

  const CarouselWidgetViewModel({this.autoPlay = false, this.currentPage = 0});

  //  static method  to lookup an inherited widget model.
  static CarouselWidgetViewModel of(BuildContext context) {
    final CarouselWidgetModelBinding binding =
        context.inheritFromWidgetOfExactType(CarouselWidgetModelBinding);
    return binding?.model ?? CarouselWidgetViewModel();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CarouselWidgetViewModel otherModel = other;
    return otherModel.autoPlay == autoPlay &&
        otherModel.currentPage == currentPage;
  }

  @override
  int get hashCode => autoPlay.hashCode + currentPage;
}

// InheritedWidget subcla called ViewModelBinding because it connects the application’s widgets to the view model.
// InheritedWidgets keep track of their dependents, i.e. the BuildContexts from which the InheritedWidget was accessed.
// When an InheritedWidget is rebuilt, all of its dependents are rebuilt as well.
class CarouselWidgetModelBinding extends InheritedWidget {
  CarouselWidgetModelBinding({
    Key key,
    this.model = const CarouselWidgetViewModel(),
    Widget child,
  })  : assert(model != null),
        super(key: key, child: child);

  final CarouselWidgetViewModel model;

  // Called when the ModelBinding is rebuilt. If it returns true,
  // then all of the dependent widgets are rebuilt.
  @override
  bool updateShouldNotify(CarouselWidgetModelBinding oldWidget) =>
      model != oldWidget.model;
}
