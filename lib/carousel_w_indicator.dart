import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_carousel/globals.dart' as globals;

Widget testCarousel = new Container(
    child: new CarouselSlider(
        items: globals.imageNames.map((i) {
          return new Builder(
            builder: (BuildContext context) {
              return new Container(
                  width: MediaQuery.of(context).size.width,
//                    margin: new EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: new BoxDecoration(color: Colors.lime),
                  child: new Image(
                      image: new AssetImage('images/$i.jpg'),
                      width: MediaQuery.of(context).size.width,
                      height: 1080.0,
                      fit: BoxFit.cover));
            },
          );
        }).toList(),
        height: 800.0,
        autoPlay: true));

final List _carouselWidthIndicator =
    globals.map<Widget>(globals.imageNames, (index, i) {
  return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              new Image(
                  image: new AssetImage('images/$i.jpg'),
                  width: 1920.0,
                  height: 1080.0,
                  fit: BoxFit.cover),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        '#${index + 1} - $i.jpg',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
            ],
          )));
}).toList();

class ViewModel {
  const ViewModel({this.autoPlay = false, this.currentPage = 0});
  final bool autoPlay;
  final int currentPage;

  //  static method  to lookup an inherited widget model.
  static ViewModel of(BuildContext context) {
    final ViewModelBinding binding =
        context.inheritFromWidgetOfExactType(ViewModelBinding);
    return binding.model;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ViewModel otherModel = other;
    return otherModel.autoPlay == autoPlay &&
        otherModel.currentPage == currentPage;
  }

  @override
  int get hashCode => autoPlay.hashCode + currentPage;
}

// InheritedWidget subcla called ViewModelBinding because it connects the application’s widgets to the view model.
// InheritedWidgets keep track of their dependents, i.e. the BuildContexts from which the InheritedWidget was accessed.
// When an InheritedWidget is rebuilt, all of its dependents are rebuilt as well.
class ViewModelBinding extends InheritedWidget {
  ViewModelBinding({
    Key key,
    this.model = const ViewModel(),
    Widget child,
  })  : assert(model != null),
        super(key: key, child: child);

  final ViewModel model;

  // Called when the ModelBinding is rebuilt. If it returns true,
  // then all of the dependent widgets are rebuilt.
  @override
  bool updateShouldNotify(ViewModelBinding oldWidget) =>
      model != oldWidget.model;
}

class CarouselWithIndicator extends StatelessWidget {
  final ValueChanged<ViewModel> updateModel;

  const CarouselWithIndicator({Key key, this.updateModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: _carouselWidthIndicator,
        autoPlay: ViewModel.of(context).autoPlay,
        aspectRatio: 2.0,
        updateCallback: (index) {
          updateModel(ViewModel(currentPage: index));
        },
      ),
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: globals.map<Widget>(globals.imageNames, (index, name) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ViewModel.of(context).currentPage == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4)),
          );
        }),
      ))
    ]);
  }
}
