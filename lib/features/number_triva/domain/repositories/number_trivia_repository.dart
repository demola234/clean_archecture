import 'package:dartz/dartz.dart';
import 'package:learing_tdd/core/error/failures.dart';
import 'package:learing_tdd/features/number_triva/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
