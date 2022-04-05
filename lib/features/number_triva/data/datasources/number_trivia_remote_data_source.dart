import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learing_tdd/core/error/exceptions.dart';
import 'package:learing_tdd/features/number_triva/data/models/number_trivia_models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTriverFromUrl("http://numbers.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriverFromUrl("http://numbers.com/random");
  }

  Future<NumberTriviaModel> _getTriverFromUrl(String url) async {
    final response = await client.get(
      Uri(path: url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerExpections();
    }
  }
}
