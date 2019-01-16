import 'package:flutter_carousel/models/winner.dart';
import 'package:flutter_carousel/services/napisorsjegy_api.dart';
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

  InfiniteListDemoViewModel({@required this.api});

  Future<bool> setWinners({int offset = 0}) async {
    winners = api?.getWinners(offset: offset);
    print("$runtimeType: setWinners  offset: $offset");
    return winners != null;
  }

  Future<List<Winner>> loadPage({int offset = 0}) async {
    print("$runtimeType: loadPage offset: $offset");
    return api?.getWinners(offset: offset);
  }
}
