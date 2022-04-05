import 'package:dartz/dartz.dart';
import 'package:learing_tdd/core/error/failures.dart';
import 'package:learing_tdd/core/usecases/usecases.dart';
import 'package:learing_tdd/features/number_triva/domain/entities/number_trivia.dart';
import 'package:learing_tdd/features/number_triva/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noparams) async {
    return await repository.getRandomNumberTrivia();
  }
}

