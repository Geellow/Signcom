import 'package:flutter/material.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Colors.dart';

class OptionC extends StatelessWidget {
  const OptionC({Key? key, required this.option, required this.color}) : super(key: key);
  final String option;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card (
      color: color,
    child: ListTile(
      title: Text(
        option,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22.0,
          color: color.red != color.green ? neutral : Colors.black,
         ),
       ),
     ),
    );
  }
}