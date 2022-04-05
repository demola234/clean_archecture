import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:learing_tdd/core/error/exceptions.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/models/number_trivia_models.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something was wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test("should perform a GET Request with number being the endpoint",
        () async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(Uri(path: 'http://numbers.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test("should return NumberTrivia when Response Code is equal to 200",
        () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw an ServerException", () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerExpections>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test("should perform a GET Request with number being the endpoint",
        () async {
      setUpMockHttpClientSuccess200();
      dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(Uri(path: 'http://numbers.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test("should return NumberTrivia when Response Code is equal to 200",
        () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw an ServerException", () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getRandomNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<ServerExpections>()));
    });
  });
}
