import 'dart:async';

import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/models/winner.dart';
import 'package:flutter_carousel/services/napisorsjegy_api.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class InfiniteListDemoViewModel extends Model {
  Future<List<Winner>> _winners;
  Future<List<Winner>> get winners => _winners;
  set winners(Future<List<Winner>> value) {
    _winners = value;
    notifyListeners();
  }

  final NapisorsjegyApi api;
  static Logger _logger = newLogger("InfiniteListDemoViewModel");

  InfiniteListDemoViewModel({@required this.api});

  Future<List<Winner>> loadPage({int page = 0, int limit = 10}) async {
    _logger.fine("loadPage page: $page, limit: $limit");
    return api?.getWinners(page: page, limit: limit);
  }
}
