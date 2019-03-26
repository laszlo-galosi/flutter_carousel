import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  FocusNode _focusNode;
  TextAlign _textAlign = TextAlign.start;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(_handleFocusChanged);
//    _handleFocusChanged();
  }

  void _handleFocusChanged() {
    setState(() {
      _textAlign = _focusNode.hasFocus ? TextAlign.start : TextAlign.center;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text('Test')),
        body: Column(children: [
          new TextFormField(
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              hintText: "Enter your full name",
              labelText: "Name",
            ),
            textAlign: _textAlign,
            initialValue: '10000',
            focusNode: _focusNode,
            autofocus: true,
          ),
          SizedBox(
            height: 24.0,
          ),
          FlatButton(
            color: Colors.indigo,
            textColor: Colors.white,
            child: Text('${_focusNode.hasFocus ? "Unfocus" : "Focus"} field.'),
            onPressed: () => _focusNode.hasFocus
                ? _focusNode.unfocus()
                : FocusScope.of(context).requestFocus(_focusNode),
          ),
        ]));
  }
}
