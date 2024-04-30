import 'package:flutter/material.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Colors.dart';
class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key,
  required this.question,
  required this.indexAction,
  required this.totalQuestion,
  required this.ImageUrl,
  })
  : super (key: key);



  final String question;
  final int indexAction;
  final int totalQuestion;
  final String ImageUrl;


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('Question ${indexAction + 1}/$totalQuestion: $question',
      style: TextStyle(
        fontSize: 20.0,
        color: neutral,
      ),
      ),
    );
  }
}