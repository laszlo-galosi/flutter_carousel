import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

const _materialPadding = EdgeInsets.all(16.0);

const _imageNames = [917971, 965986, 900890, 836945, 941223, 952679];

Widget _testCarousel = new Container(
    child: new CarouselSlider(
        items: _imageNames.map((i) {
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

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

final List _carouselWidthIndicator = map<Widget>(_imageNames, (index, i) {
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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Carousel Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Flutter Carousel Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CarouselWithIndicator extends StatefulWidget {
  CarouselWithIndicator({Key key, this.autoPlay}) : super(key: key);

  bool autoPlay = false;

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  bool _isAuto = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: _carouselWidthIndicator,
        autoPlay: _isAuto,
        aspectRatio: 2.0,
        updateCallback: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Container(
          //top: 0.0,
          //left: 0.0,
          //right: 0.0,
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(_imageNames, (index, name) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4)),
          );
        }),
      ))
    ]);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool _autoPlay = true;

  void toggleAutoPlay() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _autoPlay = !_autoPlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was createdP bPy
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(child: CarouselWithIndicator(autoPlay: _autoPlay)
          //Padding(
          //  padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //  child: _testCarousel,
          //),

          ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleAutoPlay,
        tooltip: 'Autoplay',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
