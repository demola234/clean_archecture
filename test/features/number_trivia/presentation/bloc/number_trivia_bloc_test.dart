// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:learing_tdd/core/utils/input_converter.dart';
// import 'package:learing_tdd/features/number_triva/domain/entities/number_trivia.dart';
// import 'package:learing_tdd/features/number_triva/domain/usecases/get_concrete_number_trivia.dart';
// import 'package:learing_tdd/features/number_triva/domain/usecases/get_random_number_trivia.dart';
// import 'package:learing_tdd/features/number_triva/presentation/bloc/number_trivia_bloc.dart';
// import 'package:mockito/mockito.dart';

// class MockGetContreteNumberTrivia extends Mock
//     implements GetConcreteNumberTrivia {}

// class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

// class MockInput extends Mock implements InputConverter {}

// void main() {
//   MockGetContreteNumberTrivia mockGetContreteNumberTrivia;
//   MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
//   MockInput mockInput;
//   NumberTriviaBloc bloc;

//   setUp(() {
//     mockGetContreteNumberTrivia = MockGetContreteNumberTrivia();
//     mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
//     mockInput = MockInput();
//     bloc = NumberTriviaBloc(
//         concreteNumber: mockGetContreteNumberTrivia,
//         randomNumberTrivia: mockGetRandomNumberTrivia,
//         inputConverter: mockInput);
//   });

//   group("GetTriviaForConcreteNumber", () {
//     final tNumberString = "1";
//     final tNumber = 1;
//     final tNumberTrivia = NumberTrivia(text: "text", number: 1);

//     void setUpMockInputConverterSuccess() =>
//         when(mockInput.stringToUnsignedInteger(any)).thenReturn(Right(tNumber));

//     test(
//         "should call the InputConverter to validate and convert the string of unsigned integer",
//         () async {
//       setUpMockInputConverterSuccess();
//       bloc.add(GetTriviaForConcreteNumber(tNumberString));
//       await untilCalled(mockInput.stringToUnsignedInteger(any));
//       verify(mockInput.stringToUnsignedInteger(tNumberString));
//     });

//     test("should return ERROR when input is invalid", () async {
//       when(mockInput.stringToUnsignedInteger(any))
//           .thenReturn(Left(InvalidInputFailure()));

//       expectLater(
//           bloc,
//           emitsInOrder([
//             Empty(),
//             Failure(message: SERVER_FAILURE_MESSAGE),
//           ]));
//       bloc.add(GetTriviaForConcreteNumber(tNumberString));
//     });

//     test("should get data from the concrete usecase", () async {
//       setUpMockInputConverterSuccess();
//       when(mockGetContreteNumberTrivia(any))
//           .thenAnswer((_) async => Right(tNumberTrivia));
//       bloc.add(GetTriviaForConcreteNumber(tNumberString));
//       await untilCalled(mockInput.stringToUnsignedInteger(any));
//       verify(mockGetContreteNumberTrivia(Params(number: tNumber)));
//     });
//   });
// }
