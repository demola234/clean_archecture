import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:learing_tdd/features/number_triva/data/models/number_trivia_models.dart';
import 'package:learing_tdd/features/number_triva/domain/entities/number_trivia.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: "test", number: 1);

  test("should be a subclass of number trivia entity", () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("should return a model when the json number is an integer", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test("should rereturn a model when the json number is a double ", () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture("trivia_double.json"));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group("tojson", () {
    test("should pass JSON map containing proper data", () async {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "test",
        "number": 1
      };
      expect(result, expectedMap);
    });
  });
}
