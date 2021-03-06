import 'package:learing_tdd/core/error/exceptions.dart';
import 'package:learing_tdd/core/network/network_info.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learing_tdd/features/number_triva/domain/entities/number_trivia.dart';
import 'package:learing_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:learing_tdd/features/number_triva/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImp implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImp({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerExpections {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheExpections {
        return Left(CacheFailure());
      }
    }
  }
}
