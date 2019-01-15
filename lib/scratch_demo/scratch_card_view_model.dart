import 'package:flutter/cupertino.dart';
import 'package:flutter_carousel/scratch_demo/scratch_card_view.dart';

class _ScratchCardModelBindingWidget extends InheritedWidget {
  _ScratchCardModelBindingWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final ScratchCardWidgetState data;

  @override
  bool updateShouldNotify(_ScratchCardModelBindingWidget oldWidget) {
    return true;
  }
}
