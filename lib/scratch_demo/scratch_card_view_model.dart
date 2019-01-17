import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel/scratch_demo/scratch_card_widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sprintf/sprintf.dart';

///[Model] for storing [ScratchCardWidget] state and properties.
class ScratchCardViewModel extends Model {
  double _revealedPercent = 0.0;

  /// Returns the percent of the scratched pixels relative to the widget pixels
  /// of the [ScratchCardLayout].
  double get revealedPercent => _revealedPercent;

  set revealedPercent(double percent) {
    _revealedPercent = percent;
    notifyListeners();
  }

  Uint8List _capturedImage;

  int _initialPixelSize;

  ///Returns the length of the in memory image byte array of [ScratchCardLayout] widget.
  int get initialPixelSize => _initialPixelSize;

  ///Returns the byte array representation of the [ScratchCardLayout] widget image in memory.
  Uint8List get capturedImage => _capturedImage;

  /// Setter for the in memory image of the [ScratchCardLayout] widget.
  /// If not set tje [_initialPixelSize] is set for the first time, and
  /// determines the [_revealedPercent] by calling [_countScratchedPixels]
  set capturedImage(Uint8List imagePixels) {
    if (_capturedImage == null) {
      _initialPixelSize = imagePixels.lengthInBytes;
    }
    _capturedImage = imagePixels;
    int count = _countScratchedPixels();
    _revealedPercent = count / _initialPixelSize;
    print(sprintf("_transparentPixelPercent count/lenght: %d/%d, percent: %.5f",
        [count, _initialPixelSize, _revealedPercent]));
    notifyListeners();
  }

  bool _debugMode = false;

  bool get debugMode => _debugMode;

  set debugMode(bool mode) {
    _debugMode = mode;
    notifyListeners();
  }

  bool _captureInProgress = false;

  /// Returns true  if the in memory image is being captured via [RenderRepaintBoundary]
  /// toImage.
  bool get captureInProgress => _captureInProgress;

  set captureInProgress(bool mode) {
    _captureInProgress = mode;
    notifyListeners();
  }

  bool _completed = false;

  ///Returns true if the [_revealedPercent] > as [ScratchCardWidget.completeThreshold]
  bool get isCompleted => _completed;

  set completed(bool value) {
    _completed = value;
    notifyListeners();
  }

  bool _defaultState = false;

  /// Returns true, the scratched image is in default state, meaning, any
  /// the full image is intact, all the [ScratchData] cleared.
  bool get isInDefaultState => _defaultState;

  void setDefaultState(bool value) {
    _defaultState = value;
    if (value) {
      _completed = false;
      _revealedPercent = 0.0;
    }
    notifyListeners();
  }

  /// Counts the 'scratched' e.g. transparent pixels of [capturedImage].
  int _countScratchedPixels() {
    if (_capturedImage == null) return 0;
    int count = _initialPixelSize;
    _capturedImage.forEach((pixel) {
      if (pixel > 0) count--;
    });
    return count;
  }
}

///Scratch data storing all the points [Offset]s of the [ScratchCardLayout] widget.
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
