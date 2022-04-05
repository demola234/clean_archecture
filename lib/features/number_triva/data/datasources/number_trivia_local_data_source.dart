import 'dart:convert';

import 'package:learing_tdd/core/error/exceptions.dart';
import 'package:learing_tdd/features/number_triva/data/models/number_trivia_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviatoCache);
}

const CACHE_NUMBER_TRIVIA = "CACHE_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHE_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheExpections();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviatoCache) {
    return sharedPreferences.setString(
        CACHE_NUMBER_TRIVIA, json.encode(triviatoCache.toJson()));
  }
}
