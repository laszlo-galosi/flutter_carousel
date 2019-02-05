library flutter_carousel.globals;

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

List<int> imageNames = [917971, 965986, 900890, 836945, 941223, 952679];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

Logger _logger;

Logger get log => _logger;

void initLogger(String name) {
  hierarchicalLoggingEnabled = true;
  _logger = new Logger(name);
  _logger.level = Level.ALL;
  _logger.onRecord.listen((LogRecord rec) {
    debugPrint(
        '\t${rec.level.name} - ${rec.time} - ${rec.loggerName}: ${rec.message}');
  });
}

Widget matchParent(Widget child,
    [double width = double.infinity, double height]) {
  return new ConstrainedBox(
    constraints: BoxConstraints.tightFor(width: width, height: height),
    child: child,
  );
}
