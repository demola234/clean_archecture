import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learing_tdd/features/number_triva/presentation/bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Number Trivia"),
        ),
        body: Column(children: [
          Container(child:
              Container(child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is Empty) {
                return Container(
                  height: 200,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.black),
                );
              }
            },
          )))
        ]));
  }
}
