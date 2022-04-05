import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learing_tdd/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringTosignedInt", () {
    test(
        "should return n integer when the string represent an unsigned  integer ",
        () async {
      final str = "123";
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });
  });


   test(
        "should return n integer when the string represent an not an integer ",
        () async {
      final str = "abc";
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });


    test(
        "should return n integer when the string represent an not an integer ",
        () async {
      final str = "-123";
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
}
