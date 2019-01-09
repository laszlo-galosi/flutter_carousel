// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';

const _padding = EdgeInsets.all(16.0);

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          accentColor: Colors.deepOrange, primarySwatch: Colors.indigo),
      title: 'Hello Rectangle',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Flutter'),
        ),
        body: HelloRectangle(),
        floatingActionButton: new FloatingActionButton(
          onPressed: onActionClicked,
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),
    ),
  );
}

void onActionClicked() {
  print("Clicked");
}

class HelloRectangle extends StatelessWidget {
  HelloRectangle();

  factory HelloRectangle.forDesignTime() {
    return new HelloRectangle();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: _padding,
            color: Colors.indigo,
            height: 300.0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Hello Flutter!',
                      style: TextStyle(fontSize: 32.0, color: Colors.white),
                      textAlign: TextAlign.center),
                  Expanded(
                    child: new FittedBox(
                      fit: BoxFit.contain, // otherwise the logo will be tiny
                      child: const FlutterLogo(colors: Colors.orange),
                    ),
                  ),
                ])));
  }
}
