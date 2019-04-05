import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:url_launcher/url_launcher.dart';

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

void initLogger(String name, {String package = 'flutter_carousel'}) {
  hierarchicalLoggingEnabled = true;
  _logger = new Logger(name);
  _logger.level = Level.ALL;
  _logger.onRecord.listen((LogRecord rec) {
    final List<Frame> frames = Trace.current().frames;
    final Frame f = frames.skip(1).firstWhere((Frame f) => f.package == package,
        orElse: () => frames.first);
    dev.log('(${f.library}:${f.line}): ${rec.message}',
        level: rec.level.value, name: rec.loggerName, time: DateTime.now());
//    print(
//        '${rec.level.name}/${rec.loggerName}: ${f.member} (${f.library}:${f.line}): ${rec.message}');
//    debugPrint(
//        '\t${rec.level.name} - ${rec.time} - ${rec.loggerName}: ${rec.message}');
  });
}

Logger newLogger(String name, {String package = 'flutter_carousel'}) {
  hierarchicalLoggingEnabled = true;
  final logger = new Logger(name);
  logger.level = Level.ALL;
  logger.onRecord.listen((LogRecord rec) {
    final List<Frame> frames = Trace.current().frames;
    final Frame f = frames.skip(1).firstWhere((Frame f) => f.package == package,
        orElse: () => frames.first);
    dev.log('(${f.library}:${f.line}): ${rec.message}',
        level: rec.level.value, name: rec.loggerName, time: DateTime.now());
//    print(
//        '\t${rec.level.name} - ${rec.loggerName}: ${f.member} (${f.package}/${f.library}:${f.line}): ${rec.message}');
  });
  return logger;
}

Widget matchParent(Widget child,
    [double width = double.infinity, double height]) {
  return new ConstrainedBox(
    constraints: BoxConstraints.tightFor(width: width, height: height),
    child: child,
  );
}

AlignmentDirectional alignmentFor(TextAlign textAlign) {
  switch (textAlign) {
    case TextAlign.start:
    case TextAlign.left:
      return AlignmentDirectional.centerStart;
    case TextAlign.end:
    case TextAlign.right:
      return AlignmentDirectional.centerEnd;
    case TextAlign.center:
      return AlignmentDirectional.center;
    default:
      return AlignmentDirectional.centerStart;
  }
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Offset getPosition(GlobalKey key) {
  final renderObject = key.currentContext?.findRenderObject();
  return renderObject != null
      ? (renderObject as RenderBox).localToGlobal(Offset.zero)
      : null;
}

Size getSize(GlobalKey key) {
  final renderObject = key.currentContext?.findRenderObject();
  return renderObject != null ? (renderObject as RenderBox).size : null;
}

DateTime withZeroTime(DateTime date) =>
    new DateTime(date.year, date.month, date.day);
