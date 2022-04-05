import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learing_tdd/features/number_triva/presentation/bloc/number_trivia_bloc.dart';
import 'features/number_triva/presentation/pages/number_trivia.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BlocProvider<NumberTriviaBloc>(
        create: (context) => sl<NumberTriviaBloc>(),
        child: NumberTriviaPage(),
      ),
    );
  }
}
