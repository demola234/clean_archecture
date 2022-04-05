import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learing_tdd/core/error/exceptions.dart';
import 'package:learing_tdd/core/error/failures.dart';
import 'package:learing_tdd/core/network/network_info.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/models/number_trivia_models.dart';
import 'package:learing_tdd/features/number_triva/data/repositories/number_trivia_repository_imp.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImp repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImp(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runtestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runtestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("get concentrate number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "text", number: tNumber);
    final tNumberTrivia = tNumberTriviaModel;

    test("should check if device is online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    runtestOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          "should return remote data when the call is to remote data source is connnected",
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          "should return cache data locally when the call is to remote data source is connnected",
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
      });
      test(
          "should return server failure when the call is to remote data source is failed",
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerExpections());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runtestOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("should return cache failure when their is data present", () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(tNumberTrivia)));
      });
    });
    // test("should return cache failure when their is no cached data", () async {
    //   when(mockLocalDataSource.getLastNumberTrivia())
    //       .thenThrow(CacheExpections());
    //   final result = await repository.getConcreteNumberTrivia(1);
    //   verify(mockLocalDataSource.getLastNumberTrivia());
    //   verifyZeroInteractions(mockRemoteDataSource);
    //   expect(result, equals(Left(CacheFailure())));
    // });
  });

  group("get random number trivia", () {
    final tNumberTriviaModel = NumberTriviaModel(text: "text", number: 1234);
    final tNumberTrivia = tNumberTriviaModel;

    test("should check if device is online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    runtestOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          "should return remote data when the call is to remote data source is connnected",
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          "should return cache data locally when the call is to remote data source is connnected",
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
      });
      test(
          "should return server failure when the call is to remote data source is failed",
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerExpections());
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runtestOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("should return cache failure when their is data present", () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return cache failure when their is no cached data",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheExpections());
        final result = await repository.getRandomNumberTrivia();
        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
