import 'package:flutter/material.dart';
import 'package:flutter_carousel/resources.dart' as res;

class ErrorPageWidget extends StatelessWidget {
  final VoidCallback action;
  final Widget message;

  ErrorPageWidget({this.action, this.message});

  factory ErrorPageWidget.forDesignTime() {
    return new ErrorPageWidget(action: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: res.edgeInsetsH16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          message != null
              ? message
              : Text('Connect to the internet & refresh',
                  style: res.textStyleNormal),
          Opacity(
              opacity: action != null ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.indigoAccent,
                  child: Icon(
                    Icons.refresh,
                    size: 30.0,
                  ),
                  onPressed: action ?? () {},
                ),
              )),
        ],
      ),
    );
  }
}
