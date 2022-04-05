import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:learing_tdd/core/error/failures.dart';
import 'package:learing_tdd/core/usecases/usecases.dart';
import 'package:learing_tdd/core/utils/input_converter.dart';
import 'package:learing_tdd/features/number_triva/domain/entities/number_trivia.dart';
import 'package:learing_tdd/features/number_triva/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learing_tdd/features/number_triva/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Message";
const String CACHE_FAILURE_MESSAGE = "Cache Message";
const String INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid  Input - The number must be an integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumber;
  final GetRandomNumberTrivia randomNumberTrivia;
  final InputConverter inputConverter;

  var getTriviaForConcreteNumber;
  NumberTriviaBloc({
    @required this.concreteNumber,
    @required this.randomNumberTrivia,
    @required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async* {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither.fold(
          (failure) async* {
            yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
          },
          (integer) async* {
            yield Loading();
            final failureOrTrivia =
                await concreteNumber(Params(number: integer));
            yield failureOrTrivia.fold(
                (failure) => Error(message: _mapFailureToMessage(failure)),
                (trivia) => Loaded(trivia: trivia));
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        yield Loading();
        final failureOrTrivia = await randomNumberTrivia(NoParams());
        yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
