import 'package:flutter/material.dart';

class button1 extends StatelessWidget {
  final void Function(int) nextQuestion;
  const button1({Key? key, required this.nextQuestion}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:  () => nextQuestion(10),
      child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const  EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: const Text('Next Question',
      textAlign: TextAlign.center,
      ),
      )
    );
  }
}