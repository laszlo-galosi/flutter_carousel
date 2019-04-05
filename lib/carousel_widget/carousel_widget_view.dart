import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/carousel_widget/carousel_widget_view_model.dart';
import 'package:flutter_carousel/globals.dart' as globals;
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;

class CarouselPageWidget extends StatefulWidget {
  @override
  _CarouselPageWidgetState createState() => new _CarouselPageWidgetState();
}

class _CarouselPageWidgetState extends State<CarouselPageWidget> {
  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return new CarouselWidget(
        child: new Scaffold(
            appBar: AppBar(
              title: Text(navState.selectedItem?.title ?? "",
                  style: res.textStyleTitleDark,),
              leading: IconButton(
                icon: Icon(
                    navState.shouldGoBack ? res.backIcon(context) : Icons.menu),
                onPressed: () {
                  if (navState.shouldGoBack) {
                    navState.navigator.currentState.pop();
                  } else {
                    RootScaffold.openDrawer(context);
                  }
                },
              ),
            ),
            body: new CarouselWidgetView()));
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
    CarouselSlider carouselSlider = CarouselSlider(
      items: _carouselWidthIndicatorUI,
      aspectRatio: 2.0,
      onPageChanged: (index) {
        state.setCurrentPage(index);
      },
      autoPlay: state.autoPlay,
    );
    return Column(
      children: [
        carouselSlider,
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
        )),
        Row(children: <Widget>[
          Expanded(
              child: new IconButton(
            icon: new Icon(Icons.chevron_left),
            iconSize: 32,
            onPressed: () {
              carouselSlider.previousPage(
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            },
          )),
          Expanded(
              child: Text(
            "page: ${state.currentPage}",
            style: res.textStyleNormal,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: new IconButton(
            icon: new Icon(Icons.chevron_right),
            iconSize: 32,
            onPressed: () {
              carouselSlider.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            },
          )),
        ]),
      ],
    );
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
