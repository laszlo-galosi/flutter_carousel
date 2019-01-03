import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart' as globals;

import './carousel_widget_view_model.dart';

class CarouselWidgetView extends StatelessWidget {
  final ValueChanged<CarouselWidgetViewModel> updateModel;

  const CarouselWidgetView({Key key, this.updateModel}) : super(key: key);

  factory CarouselWidgetView.forDesignTime() {
    // TODO: add arguments
    return new CarouselWidgetView();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: _carouselWidthIndicatorUI,
        aspectRatio: 2.0,
        updateCallback: (index) {
          updateModel(CarouselWidgetViewModel(currentPage: index));
        },
        autoPlay: CarouselWidgetViewModel.of(context)?.autoPlay ?? false,
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
                color: CarouselWidgetViewModel.of(context)?.currentPage == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4)),
          );
        }),
      ))
    ]);
  }
}

final List _carouselWidthIndicatorUI =
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
