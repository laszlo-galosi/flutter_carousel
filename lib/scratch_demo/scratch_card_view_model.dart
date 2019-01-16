import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';

class _ScratchCardModelBindingWidget extends InheritedWidget {
  _ScratchCardModelBindingWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final ScratchCardBindingWidgetState data;

  @override
  bool updateShouldNotify(_ScratchCardModelBindingWidget oldWidget) {
    return true;
  }
}

class ScratchCardBindingWidget extends StatefulWidget {
  ScratchCardBindingWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ScratchCardBindingWidgetState createState() =>
      new ScratchCardBindingWidgetState();

  static ScratchCardBindingWidgetState of(
      [BuildContext context, bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(
                    _ScratchCardModelBindingWidget)
                as _ScratchCardModelBindingWidget
            : context.ancestorWidgetOfExactType(_ScratchCardModelBindingWidget)
                as _ScratchCardModelBindingWidget)
        .data;
  }
}

class ScratchCardBindingWidgetState extends State<ScratchCardBindingWidget> {
  /// List of Items
  double _revealedPercent = 0.0;

  double get revealPercent => _revealedPercent;

  set revealPercent(double percent) {
    setState(() {
      _revealedPercent = percent;
    });
  }

  Uint8List _capturedImage;

  int _initialPixelSize;

  int get initialPixelSize => _initialPixelSize;

  Uint8List get capturedImage => _capturedImage;

  set capturedImage(Uint8List imagePixels) {
    setState(() {
      if (_capturedImage == null) {
        _initialPixelSize = imagePixels.lengthInBytes;
      }
      _capturedImage = imagePixels;
      int count = _countScratchedPixels();
      _revealedPercent = count / _initialPixelSize;
      print(sprintf(
          "_transparentPixelPercent count/lenght: %d/%d, percent: %.5f",
          [count, _initialPixelSize, _revealedPercent]));
    });
  }

  bool _debugMode = false;
  bool get debugMode => _debugMode;

  set debugMode(bool mode) {
    setState(() {
      _debugMode = mode;
    });
  }

  bool _captureInProgress = false;

  bool get captureInProgress => _captureInProgress;

  bool _completed = false;

  bool get isCompleted => _completed;

  set completed(bool value) {
    setState(() {
      _completed = value;
    });
  }

  set captureInProgress(bool mode) {
    setState(() {
      _captureInProgress = mode;
    });
  }

  int _countScratchedPixels() {
    if (_capturedImage == null) return 0;
    int count = _initialPixelSize;
    _capturedImage.forEach((pixel) {
      if (pixel > 0) count--;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return new _ScratchCardModelBindingWidget(
      data: this,
      child: widget.child,
    );
  }
}

class ScratchData extends ChangeNotifier {
  List<Offset> _points = [];

  List<Offset> get points => _points;

  void addPoint(Offset offset) {
    _points.add(offset);
    notifyListeners();
  }

  void clear() {
    _points.clear();
    notifyListeners();
  }
}
