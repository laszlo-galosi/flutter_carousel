import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel/scratch_demo/scratch_card_view_model.dart';

typedef ScratchPercentCallback = void Function(double percent);

class ScratchCardWidget extends StatefulWidget {
  ScratchCardWidget(
      {Key key,
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

  @override
  ScratchCardWidgetState createState() => new ScratchCardWidgetState();
}

class ScratchCardWidgetState extends State<ScratchCardWidget> {
  ScratchCardWidgetState();

  ScratchData _data = ScratchData();

  GlobalKey _cardLayoutKey = GlobalKey();

  /// The last local point in local coordinates at which the
  /// pointer contacted the screen.
  Offset _lastPoint;

  StreamSubscription _timerSub;

  ScratchCardBindingWidgetState _bindingState;

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
    _capturePixels();
    _stopTimer();
  }

  void _startTimer() {
    if (_timerSub != null) _timerSub.cancel();
    _timerSub = new Stream.periodic(const Duration(milliseconds: 500), (v) => v)
//          .take(10)
        .listen((tick) {
      print("Timer tick $tick");
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
    super.dispose();
  }

  Future<Uint8List> _capturePixels() async {
    try {
      print('captureImage inside: $_bindingState');
      if (_bindingState.captureInProgress) return _bindingState.capturedImage;

      RenderRepaintBoundary boundary =
          _cardLayoutKey.currentContext.findRenderObject();
      if (boundary.debugNeedsPaint) return null;
      _bindingState.captureInProgress = true;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
//      String bs64 = base64Encode(pngBytes);_to
      print(pngBytes);
//      print(bs64);
      print('_capturePixels done');
      //setState(() {
      //_imageInMemory = pngBytes;
      _bindingState.capturedImage = pngBytes;
      widget.onScratch(_bindingState.revealPercent);
      _bindingState.captureInProgress = false;
      //});
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //_capturePixels();
    _bindingState = ScratchCardBindingWidget.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.reveal,
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
    print("_data.length ${_data.points.length}");
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
      Paint fill = Paint()
        ..blendMode = _data.points.isEmpty ? BlendMode.src : BlendMode.clear;
      _data.points.forEach((point) =>
          context.canvas.drawCircle(offset + point, _strokeWidth, fill));
      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}
