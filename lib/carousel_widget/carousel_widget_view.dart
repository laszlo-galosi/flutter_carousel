import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart' as globals;
import 'package:flutter_carousel/resources.dart' as res;

import './carousel_widget_view_model.dart';

class CarouselPageWidget extends StatefulWidget {
  @override
  _CarouselPageWidgetState createState() => new _CarouselPageWidgetState();
}

class _CarouselPageWidgetState extends State<CarouselPageWidget> {
  @override
  Widget build(BuildContext context) {
    return new CarouselWidget(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('Carousel Demo', style: res.textStyleTitleDark),
            ),
            body: new CarouselWidgetView(),
            floatingActionButton: AutoplayButton()));
  }
}

class AutoplayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CarouselWidgetState state = CarouselWidget.of(context);
    return new FloatingActionButton(
        tooltip: "Autoplay",
        child: Icon(state.autoPlay ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          state.setAutoPlay(!state.autoPlay);
        });
  }
}

class CarouselWidgetView extends StatelessWidget {
  const CarouselWidgetView({Key key}) : super(key: key);

  factory CarouselWidgetView.forDesignTime() {
    return new CarouselWidgetView();
  }

  @override
  Widget build(BuildContext context) {
    CarouselWidgetState state = CarouselWidget.of(context);
    return Column(children: [
      CarouselSlider(
        items: _carouselWidthIndicatorUI,
        aspectRatio: 2.0,
        updateCallback: (index) {
          state.setCurrentPage(index);
        },
        autoPlay: state?.autoPlay ?? false,
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
                    color: state?.currentPage == index
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
