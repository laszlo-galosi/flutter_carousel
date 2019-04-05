import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();

main() async {
  final server = Jaguar();
  server.addRoute(serveFlutterAssets());
  await server.serve(logRequests: true);

  server.log.onRecord.listen((r) => print(r));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Jaguar Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Jaguar Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
        url: 'http://localhost:8080/filechooser.html',
        appBar: new AppBar(
          title: new Text(title),
        ),
        initialChild: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: AlignmentDirectional.bottomEnd,
          padding: EdgeInsets.all(16.0),
          child: new FloatingActionButton(
            onPressed: () {
              flutterWebviewPlugin
                  .launch('http://localhost:8080/filechooser.html');
            },
            tooltip: 'Launch',
            child: new Icon(Icons.web),
          ),
        ));
  }
}
