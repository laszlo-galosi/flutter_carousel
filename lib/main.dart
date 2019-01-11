import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/navigation/navigation_view.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp();

  factory MyApp.forDesignTime() {
    return new MyApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      initialRoute: '/',
      /* routes: {
          // When we navigate to the "/" route, build the FirstScreen Widget
          '/': (context) => MainMenuWidget(),
          // When we navigate to the other routes, cakk its PageWidgets respectively.
          '/carousel': (context) => CarouselPageWidget(),
          '/shopping': (context) => ShoppingPageWidget(),
        },*/
      onGenerateRoute: (RouteSettings settings) {
        Widget pageWidget = getPageForRouteName(settings.name);
        return Platform.isIOS
            ? new CupertinoPageRoute(
            builder: (_) => pageWidget, settings: settings)
            : MaterialPageRoute(builder: (_) => pageWidget, settings: settings);
      },
      builder: (context, child) {
        return new SharedDrawer(
            navigator: (child.key as GlobalKey<NavigatorState>),
            child: Scaffold(
              drawer: NavigationDrawerWidget(),
              body: child,
            ));
      }, //      home: HomePageView(),
    );
  }
}
