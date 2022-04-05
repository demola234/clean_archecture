import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learing_tdd/core/error/exceptions.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/models/number_trivia_models.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
    test("""should return NumberTrivia from SharedPrefences 
    when their is one in the Cache""", () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cache.json'));
      final result = await dataSource.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw cacheException when their is not a cache vaule",
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<CacheExpections>()));
    });
  });

  group("cacheNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test");

    test("should call sharedPreferences to cache data", () async {
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      verify(mockSharedPreferences.setString(
        CACHE_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
