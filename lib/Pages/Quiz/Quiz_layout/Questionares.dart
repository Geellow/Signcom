
import 'package:flutter/material.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Colors.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key,
  required this.question,
  required this.indexAction,
  required this.totalQuestion, required int totalQuestions})
  : super (key: key);



  final String question;
  final int indexAction;
  final int totalQuestion;


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
class Question {

final String id;
final String title;
final Map<String, bool> options;
final String imageUrl;


Question({
  required this.id,
  required this.title,
  required this.options,
  required this.imageUrl,
});

@override
String toString() {
    return 'Question(id: $id, title: $title, options: $options, imageUrl: $imageUrl)';
  }
}