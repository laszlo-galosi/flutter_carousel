import 'dart:async';
import 'dart:convert';

import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/models/winner.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

abstract class NapisorsjegyApi {
  Future<List<Winner>> getWinners({int page = 0, int limit = 10});
}

class NapisorsjegyApiService implements NapisorsjegyApi {
  final _baseUrl = 'https://napisorsjegy.extremenet.hu/api';
//  final _baseUrl = 'https://effisocial.com/apps/kaparossorsjegy/api';
  http.Client _client = http.Client();

  set client(http.Client value) => _client = value;

  static final NapisorsjegyApiService _internal =
      NapisorsjegyApiService.internal();
  static Logger _logger = newLogger("NapisorsjegyApiService");

  factory NapisorsjegyApiService() {
    return _internal;
  }
  NapisorsjegyApiService.internal();

  Future<List<Winner>> getWinners({int page = 0, int limit = 10}) async {
    var response = await _client
        .get('$_baseUrl/nyertesek-lista.php?page=$page&limit=$limit');

    if (response.statusCode == 200) {
      _logger.shout("getWinners: ${response.request.url}\n: ${response.body}");
      var data = json.decode(response.body);
      List<Winner> winners = [];
      data.forEach((w) => winners.add(Winner.fromMap(w)));
      return winners;
    } else {
      throw Exception('${this.runtimeType}: Failed to get data');
    }
  }
}
