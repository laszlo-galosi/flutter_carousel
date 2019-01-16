import 'dart:async';
import 'dart:convert';

import 'package:flutter_carousel/models/winner.dart';
import 'package:http/http.dart' as http;

abstract class NapisorsjegyApi {
  Future<List<Winner>> getWinners({int offset = 0});
}

class NapisorsjegyApiService implements NapisorsjegyApi {
  final _baseUrl = 'https://effisocial.com/apps/kaparossorsjegy/api';
  http.Client _client = http.Client();

  set client(http.Client value) => _client = value;

  static final NapisorsjegyApiService _internal =
      NapisorsjegyApiService.internal();
  factory NapisorsjegyApiService() => _internal;
  NapisorsjegyApiService.internal();

  Future<List<Winner>> getWinners({int offset = 0}) async {
    var response =
        await _client.get('$_baseUrl/nyertesek-lista.php?page=$offset');

    if (response.statusCode == 200) {
      print(
          "$runtimeType: getWinners offset: $offset, \n response: ${response.body}");
      var data = json.decode(response.body);
      List<Winner> winners = [];
      data.forEach((w) => winners.add(Winner.fromMap(w)));
      return winners;
    } else {
      throw Exception('${this.runtimeType}: Failed to get data');
    }
  }
}
