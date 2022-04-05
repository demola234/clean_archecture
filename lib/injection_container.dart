import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:learing_tdd/core/network/network_info.dart';
import 'package:learing_tdd/core/utils/input_converter.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learing_tdd/features/number_triva/data/repositories/number_trivia_repository_imp.dart';
import 'package:learing_tdd/features/number_triva/domain/repositories/number_trivia_repository.dart';
import 'package:learing_tdd/features/number_triva/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learing_tdd/features/number_triva/domain/usecases/get_random_number_trivia.dart';
import 'package:learing_tdd/features/number_triva/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => NumberTriviaBloc(
        concreteNumber: sl(),
        randomNumberTrivia: sl(),
        inputConverter: sl(),
      ));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImp(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<Future<SharedPreferences>>(
      () async => await SharedPreferences.getInstance());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
