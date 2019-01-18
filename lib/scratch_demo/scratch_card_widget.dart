import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel/scratch_demo/scratch_card_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

///Callback definition for subscribing to [ScratchCardViewModel] revealedPercent
///property changes.
typedef ScratchPercentCallback = void Function(double percent);

///The main widget containing the [cover] and [reveal] layers.
class ScratchCardWidget extends StatefulWidget {
  ScratchCardWidget(
      {Key key,
      @required this.cover,
      this.reveal,
      this.strokeWidth = 25.0,
      this.completeThreshold = 0.99,
      this.onComplete,
      this.onScratch,
      this.updateRevealedInterval = 500})
      : super(key: key);

  ///Th scratch able layer of the scratch card widget, which pixels are manipulated
  ///by the [_ScratchCardRender]
  final Widget cover;

  ///The layer below the [cover] which displays the information revealed by
  ///the scratch user action.
  final Widget reveal;

  ///The radius of the circles erased (set transparent) when the user scratches
  ///the [cover]
  final double strokeWidth;

  /// Callback called when the [ScratchCardViewModel#revealedPercent] is changed.
  final ScratchPercentCallback onScratch;

  /// Time interval in seconds to update [ScratchCardViewModel.revealedPercent]
  /// default is 500 seconds.
  final int updateRevealedInterval;

  /// Callback for subscribing to scratch completion, called when
  /// the [ScratchCardViewModel.revealedPercent] is > as [completeThreshold].
  final VoidCallback onComplete;

  ///Determines when the scratch card is revealed and when to call [onComplete],
  ///when the [ScratchCardViewModel.revealedPercent] is greater this value.
  final double completeThreshold;

  @override
  ScratchCardWidgetState createState() => new ScratchCardWidgetState();
}

///The main scratch card widget state.
class ScratchCardWidgetState extends State<ScratchCardWidget> {
  ScratchCardWidgetState();

  ///Contains the points of the [ScratchCardWidget.cover] layer
  ///which was scratched e.g. set to [BlendMode.clear]
  ScratchData _data = ScratchData();

  /// The key of the [ScratchCardLayout] to find its [RenderObject]
  GlobalKey _cardLayoutKey = GlobalKey();

  /// The last local point in local coordinates at which the
  /// pointer contacted the screen.
  Offset _lastPoint;

  ///Timer to save the in memory image of the [ScratchCardWidget.cover] layer
  ///as the [ScratchCardViewModel.capturedImage]
  StreamSubscription _timerSub;

  ///The view model of this widget.
  ScratchCardViewModel _viewModel;

  ///Clears all [ScratchData] to reset the image pixels.
  void reset() {
    _viewModel.setDefaultState(true);
    setState(() {
      _data.clear();
      widget.onScratch(0.0);
    });
  }

  Size _getSize() {
    return (_cardLayoutKey.currentContext.findRenderObject() as RenderBox).size;
  }

/*  Offset _getPosition() {
    return (_cardLayoutKey.currentContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
  }*/

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
    _viewModel?.setDefaultState(false);
    _startTimer();
  }

  ///Called when a pointer that is in contact with the screen and moving
  ///has moved again.
  void _onPanUpdate(DragUpdateDetails details) {
    final widgetSize = _getSize();
    final currentPoint = _globalToLocal(details.globalPosition);
    final widgetRect = Rect.fromPoints(
        Offset.zero, new Offset(widgetSize.width, widgetSize.height));
    //Omit the moving gesture if the it is outside the area of the widget.
    if (!widgetRect.contains(currentPoint)) return;

    final distance = _distanceBetween(_lastPoint, currentPoint);
    final angle = _angleBetween(_lastPoint, currentPoint);

    ///Add all points on the vector from the last point to the event point.
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
  /// It calls [_capturePixels] to update the [ScratchCardViewModel.capturedImage]
  /// if it is revealedPercent is within the [ScratchCardWidget.completeThreshold].
  void _onPanEnd(DragEndDetails details) {
    if (_viewModel.revealedPercent <= widget.completeThreshold) {
      _capturePixels();
    }
    _stopTimer();
  }

  /// Starts a periodic timer for saving the [ScratchCardWidget.cover] layer
  /// via [_capturePixels] in a different thread.
  void _startTimer() {
    if (_timerSub != null) _timerSub.cancel();
    if (_viewModel.revealedPercent > widget.completeThreshold) return;
    _timerSub = new Stream.periodic(
            Duration(milliseconds: widget.updateRevealedInterval), (v) => v)
        .listen((tick) {
//      print("Timer tick $tick");
      _capturePixels();
    });
    print("Timer started.");
  }

  /// Stops the timer to stop periodic [_capturePixels]
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

  /// Async capture of the [ScratchCardWidget.cover] layer widget pixels into
  /// a in memory via by [RenderRepaintBoundary.toImage].
  Future<Uint8List> _capturePixels() async {
    try {
      print(
          'captureImage inside: ${_viewModel.captureInProgress}, revealed ${_viewModel.revealedPercent}');
      // if capturing already started return the actual in memory image.
      if (_viewModel.captureInProgress) return _viewModel.capturedImage;

      /// Find the render object by the [ScratchCardLayout.key]
      RenderRepaintBoundary boundary =
          _cardLayoutKey.currentContext.findRenderObject();

      /// If
      if (boundary.debugNeedsPaint) return _viewModel.capturedImage;

      _viewModel.captureInProgress = true;

      /// capture the image data of the render object.
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      // convert to byte array.
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print(pngBytes);
      print('_capturePixels done');
      // update the view model and count revealedPercent.
      _viewModel.capturedImage = pngBytes;
      // call the onScratch callback.
      widget.onScratch(_viewModel.revealedPercent);

      // Determine if the scratch is completed.
      final completed = (_viewModel.revealedPercent > widget.completeThreshold);
      _viewModel.completed = completed;
      if (completed) {
        // call the onComplete callback.
        widget.onComplete();
      }
      _viewModel.captureInProgress = false;
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScratchCardViewModel>(
        builder: (context, child, model) {
      if (model.isInDefaultState) _data.clear();
      _viewModel = model;
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
              strokeWidth: model.isInDefaultState ? 0.0 : widget.strokeWidth,
              data: _data,
              child: widget.cover,
            ),
          ],
        ),
      );
    });
  }
}

/// The [ScratchCardWidget.cover] layer, so its pixels are
/// cleared when the scratching is triggered.
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

  /// the radius of the circles to be painted on a scratch point to
  /// clear its pixels when the scratch happens.
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

/// The [RenderObject] of the [ScratchCardLayout]
class _ScratchCardRender extends RenderRepaintBoundary {
  _ScratchCardRender({
    RenderBox child,
    double strokeWidth,
    ScratchData data,
  })  : assert(data != null),
        _strokeWidth = strokeWidth,
        _data = data,
        super(child: child);

  /// the radius of the circles to be painted on a scratch point to
  /// clear its pixels when the scratch happens.
  double _strokeWidth;

  /// Contains the pixels to erase with a [_strokeWidth] radius circle
  /// via [BlendMode.clear]
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
    //print("_data.length ${_data.points.length}");
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

  /// Iterates through [_data.points] to paint [_strokeWidth] radius circle
  /// with [BlendMode.clear] to erase the pixels according to the user movement.
  /// if [ScratchCardViewModel.isInDefaultState] is true, it paint 0.0 radius
  /// circles to restore the original pixels.
  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      context.paintChild(child, offset);
      if (_data.points.isEmpty) return;
      Paint fill = Paint()..blendMode = BlendMode.clear;
      _data.points.forEach((point) =>
          context.canvas.drawCircle(offset + point, _strokeWidth, fill));
      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}
