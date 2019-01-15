import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:sprintf/sprintf.dart';

class ScratchDemoPageWidget extends StatefulWidget {
  ScratchDemoPageWidget();

  factory ScratchDemoPageWidget.forDesignTime() {
    return new ScratchDemoPageWidget();
  }

  @override
  _ScratchDemoPageWidgetState createState() =>
      new _ScratchDemoPageWidgetState();
}

class _ScratchDemoPageWidgetState extends State<ScratchDemoPageWidget> {
  double _reveleadPercent = 0.0;
  GlobalKey _keyCover = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return new Scaffold(
        appBar: AppBar(
          title: Text(navState.selectedItem?.title ?? "",
              style: res.textStyleTitleDark),
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
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _reveleadPercent = 0.0;
                });
              },
            )
          ],
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              /* ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child:*/
              Container(
//                decoration: BoxDecoration(
//                    border: Border.all(color: Colors.indigo, width: 2.0)),
                width: 300.0,
                height: 300.0,
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    new ScratchCardWidget(
                        coverKey: _keyCover,
                        cover:
                            /*RepaintBoundary(
                            key: _keyCover,
                            child: */
                            /*  FittedBox(
                                fit: BoxFit.cover,
                                child:*/
//                            Opacity(opacity: 0.0),
                            Image.asset('images/itt_kapard_new.png'),
                        reveal: DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.indigo),
                          child: Center(
                              child: Text(
                            'Congratulations! You WON!',
                            style: res.textStyleTitleDark,
                          )),
                        ),
                        strokeWidth: 15.0,
                        finishPercent: 0,
                        onComplete: () => print('The card is now clear!'),
                        onScratch: (percent) {
                          setState(() {
                            print(sprintf("onScratch: %.5f", [percent]));
                            _reveleadPercent = percent;
                          });
                        }),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                    "${sprintf("Scratched: %.5f%%", [_reveleadPercent * 100])}",
                    style: res.textStyleNormal),
              ),
            ])));
  }
}

typedef ScratchPercentCallback = void Function(double percent);

class ScratchCardWidget extends StatefulWidget {
  ScratchCardWidget(
      {Key key,
      @required this.coverKey,
      @required this.cover,
      this.reveal,
      this.strokeWidth = 25.0,
      this.finishPercent = 0,
      this.onComplete,
      this.onScratch})
      : super(key: key);

  final Widget cover;
  final Widget reveal;
  final double strokeWidth;
  final int finishPercent;
  final VoidCallback onComplete;
  final ScratchPercentCallback onScratch;
  final GlobalKey coverKey;

  @override
  ScratchCardWidgetState createState() =>
      new ScratchCardWidgetState(coverKey: coverKey);
}

class ScratchCardWidgetState extends State<ScratchCardWidget> {
  ScratchCardWidgetState({@required this.coverKey});

  ScratchData _data = ScratchData();

  GlobalKey _cardLayoutKey = GlobalKey();
  final GlobalKey coverKey;

  /// The last local point in local coordinates at which the
  /// pointer contacted the screen.
  Offset _lastPoint;

  double _revealedPercent = 0.0;

  double get revealedPercent => _revealedPercent;

  bool _insideCapture = false;
  Uint8List _imageInMemory;

  StreamSubscription _timerSub;

  void reset() {
    setState(() {
      _data.clear();
      widget.onScratch(0.0);
    });
  }

  Size _getSize() {
    return (_cardLayoutKey.currentContext.findRenderObject() as RenderBox).size;
  }

  Offset _getPosition() {
    return (_cardLayoutKey.currentContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
  }

  /// Convert the given point from the global coordinate system in logical pixels
  /// to the local coordinate system for this box.
  Offset _globalToLocal(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }

  /// Returns the computed distance in double between the two given  points in
  /// local RenderBox coordinates.
  double _distanceBetween(Offset point1, Offset point2) {
    return math.sqrt(math.pow(point2.dx - point1.dx, 2) +
        math.pow(point2.dy - point1.dy, 2));
  }

  /// Returns the computed angle in double between the two given  points in
  /// local RenderBox coordinates.
  double _angleBetween(Offset point1, Offset point2) {
    return math.atan2(point2.dx - point1.dx, point2.dy - point1.dy);
  }

  /// Called when pointer has contacted the screen and might begin to move.
  void _onPanDown(DragDownDetails details) {
    _lastPoint = _globalToLocal(details.globalPosition);
    _startTimer();
  }

  ///Called when a pointer that is in contact with the screen and moving
  ///has moved again.
  void _onPanUpdate(DragUpdateDetails details) {
    final widgetSize = _getSize();
    final currentPoint = _globalToLocal(details.globalPosition);
    final widgetRect = Rect.fromPoints(
        Offset.zero, new Offset(widgetSize.width, widgetSize.height));
    if (!widgetRect.contains(currentPoint)) return;

    final distance = _distanceBetween(_lastPoint, currentPoint);
    final angle = _angleBetween(_lastPoint, currentPoint);
    for (double i = 0.0; i < distance; i++) {
      var point = Offset(
        _lastPoint.dx + (math.sin(angle) * i),
        _lastPoint.dy + (math.cos(angle) * i),
      );
      _data.addPoint(point);
    }
    _lastPoint = currentPoint;
  }

  /// Called when a pointer that was previously in contact with the screen and moving
  /// is no longer in contact with the screen and was moving at a specific
  /// velocity when it stopped contacting the screen.
  void _onPanEnd(DragEndDetails details) {
    _stopTimer();
    _capturePixels();
  }

  void _startTimer() {
    if (_timerSub != null) _timerSub.cancel();
    _timerSub = new Stream.periodic(const Duration(milliseconds: 500), (v) => v)
//          .take(10)
        .listen((count) {
      print("Timer tick $count");
      /*if (!_insideCapture) */
      _capturePixels();
    });
    print("Timer started ${_timerSub.isPaused}");
  }

  void _stopTimer() {
    if (_timerSub != null) {
      final Future result = _timerSub.cancel();
      print("Timer stopped. $result");
    }
  }

  @override
  void dispose() {
    _stopTimer();
  }

  Future<Uint8List> _capturePixels() async {
    try {
      print('captureImage inside: $coverKey, $_insideCapture');
      if (_insideCapture) return _imageInMemory;

      RenderRepaintBoundary boundary =
          _cardLayoutKey.currentContext.findRenderObject();
      if (boundary.debugNeedsPaint) return null;
      setState(() => _insideCapture = true);
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
//      String bs64 = base64Encode(pngBytes);_to
      print(pngBytes);
//      print(bs64);
      print('png done');
      setState(() {
        _imageInMemory = pngBytes;
        _insideCapture = false;
        widget.onScratch(_transparentPixelPercent(_imageInMemory));
      });
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  double _transparentPixelPercent(Uint8List imageInMemory) {
    int count = 0;
    /*_imageInMemory.fold(0, (value, pixel) {
      if (pixel == 0) value++;
    });*/
    imageInMemory.forEach((pixel) {
      if (pixel == 0) count++;
    });
//    print(sprintf("_transparentPixelPercent count/lenght: %d/%d, percent: %.5f",
//        [count, _imageInMemory.length, count / _imageInMemory.length]));
    return count.toDouble() / imageInMemory.length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.reveal,
          /* _insideCapture
              ? CircularProgressIndicator()
              : _imageInMemory != null
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Col9ors.pink, width: 2.0)),
                      child: Image.memory(_imageInMemory, scale: 0.2),
                      margin: EdgeInsets.all(10))
                  : Container(),*/
          ScratchCardLayout(
            key: _cardLayoutKey,
            strokeWidth: widget.strokeWidth,
            data: _data,
            child: widget.cover,
          ),
        ],
      ),
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

class ScratchCardLayout extends RepaintBoundary {
  ScratchCardLayout({
    Key key,
    this.strokeWidth = 25.0,
    @required this.data,
    @required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final Widget child;
  final double strokeWidth;
  final ScratchData data;

  @override
  RenderRepaintBoundary createRenderObject(BuildContext context) {
    return _ScratchCardRender(
      strokeWidth: strokeWidth,
      data: data,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _ScratchCardRender renderObject) {
    renderObject
      ..strokeWidth = strokeWidth
      ..data = data;
  }
}

class _ScratchCardRender extends RenderRepaintBoundary {
  _ScratchCardRender({
    RenderBox child,
    double strokeWidth,
    ScratchData data,
  })  : assert(data != null),
        _strokeWidth = strokeWidth,
        _data = data,
        super(child: child);

  double _strokeWidth;
  ScratchData _data;

  set strokeWidth(double strokeWidth) {
    assert(strokeWidth != null);
    if (_strokeWidth == strokeWidth) {
      return;
    }
    _strokeWidth = strokeWidth;
    markNeedsPaint();
  }

  set data(ScratchData data) {
    assert(data != null);
    if (_data == data) {
      return;
    }
    if (attached) {
      _data.removeListener(markNeedsPaint);
      data.addListener(markNeedsPaint);
    }
    _data = data;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _data.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _data.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      context.paintChild(child, offset);
      Paint clear = Paint()..blendMode = BlendMode.clear;
      _data.points.forEach((point) =>
          context.canvas.drawCircle(offset + point, _strokeWidth, clear));
      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}
