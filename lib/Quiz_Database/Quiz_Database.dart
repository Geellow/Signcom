
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signcom/Pages/Quiz/Quiz_layout/Questionares.dart';
class DBconnect {
  final url =Uri.parse('https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/Quiz.json');

  Future<void> addQuestion(Question question) async {
    http.post(url, body: json.encode({
      'title': question.title,
      'options': question.options,
      'imageURL': question.imageUrl,
    }));
  }
  Future<List<Question>> fetchQuestion() async {
    return http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];
      data.forEach((key, value) {
        var newQuestion =Question(id: key, title: value['title'], options: Map.castFrom(value['options']), imageUrl: value['imageURL']);
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }
}