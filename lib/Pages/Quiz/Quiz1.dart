import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:signcom/Pages/Home.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Colors.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Options.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Questionares.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/botton.dart';
import 'package:signcom/Quiz_Database/Quiz_Database.dart';

class Quiz_1 extends StatefulWidget {
  const Quiz_1({Key? key});

  @override
  State<Quiz_1> createState() => _Quiz1State();
}

class _Quiz1State extends State<Quiz_1> {
  var db = DBconnect();
  late DatabaseReference _userResultsRef;
  
  late Future _questions;
  bool allowAccesstoQuiz1 = true;
  bool lesson1Pressed = true;
  bool lesson2Pressed = true;
  bool allowAccesstoQuiz2 = true;
  bool allowAccesstoQuiz3 = true;
  bool allowAccesstoQuiz4 = true;
  bool allowAccesstoQuiz5 = true;
  String? userId;
  Future<List<Question>> getData() async {
    List<Question> allQuestions = await db.fetchQuestion();
    allQuestions.shuffle();
    List<Question> selectedQuestions = allQuestions.take(10).toList();
    return selectedQuestions.map((question) {
      List<MapEntry<String, bool>> entries = question.options.entries.toList();
      entries.shuffle();
      Map<String, bool> shuffledOptions = Map.fromEntries(entries);
      return Question(
        id: question.id,
        title: question.title,
        imageUrl: question.imageUrl,
        options: shuffledOptions,
      );
    }).toList();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
    _userResultsRef = FirebaseDatabase.instance.reference().child('quiz_attempts');
    _fetchUserId();
  }

  final audioCache = AudioCache();
  final player = AudioPlayer();
  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isScored = false;
  bool isAlreadySelected = false;
  Future<void> _fetchUserId () async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }
  
  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[900],
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Result",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                CircleAvatar(
                  child: Text(
                    '$score/10',
                    style: TextStyle(fontSize: 23.0),
                  ),
                  radius: 70.0,
                  backgroundColor: score == 5
                      ? Colors.blue // half score
                      : score < 5
                          ? Colors.red // less than half score
                          : Colors.green, // more than half score
                ),
                const SizedBox(height: 20.0),
                Text(
                  score == 5
                      ? 'Almost There'
                      : score < 5
                          ? 'Wanna Try Again?'
                          : 'Very Good',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                const SizedBox(height: 25.0),
                GestureDetector(
                  onTap: () {
                    restart();
                    Navigator.pop(ctx);
                  },
                  child: const Text(
                    'Restart Quiz?',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 255, 163, 1),
                      fontSize: 15.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                GestureDetector(
                  onTap: () async {
                    String? userId = FirebaseAuth.instance.currentUser?.uid;

                    await FirebaseFirestore.instance.collection('quiz_results').add({
                      'userId': userId,
                      'quizType': 'Quiz 1: Basic Alphabetics',
                      'result': score,
                      'questionLength': 10,
                      'timestamp': DateTime.now(),
                    });
                    setState(() {
                        allowAccesstoQuiz1 =!allowAccesstoQuiz1;
                        allowAccesstoQuiz2 =!allowAccesstoQuiz2;
                        allowAccesstoQuiz3 =!allowAccesstoQuiz3;
                        allowAccesstoQuiz4 =!allowAccesstoQuiz4;
                        allowAccesstoQuiz5 =!allowAccesstoQuiz5;
                        lesson1Pressed =!lesson1Pressed;
                        lesson2Pressed =!lesson2Pressed;
                        _InputButtonUserState(userId!, lesson1Pressed, lesson2Pressed, allowAccesstoQuiz1, allowAccesstoQuiz2, allowAccesstoQuiz3, allowAccesstoQuiz4, allowAccesstoQuiz5);
                      });
                    Navigator.pushAndRemoveUntil(
                      ctx,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    'Finish Quiz',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 255, 163, 1),
                      fontSize: 15.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isScored = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select any options'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  Future<void> checkAnswer(bool value) async {
    if (isScored || isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
        player.play(AssetSource('Correct.mp3'));
      } else {
        player.play(AssetSource('Incorrect.mp3'));
      }
      setState(() {
        isPressed = true;
        isScored = true;
        isAlreadySelected = true;
      });
      print('Current score: $score');
    }
  }

  void restart() async {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isScored = false;
      isAlreadySelected = false;
    });

    String quizAttemptId = _userResultsRef.push().key ?? '';

    List<String> quizIds = [
      '-NvlDKHZFDZqS-sbrQ4O',
      '-NvlEmBtza6f8SviKp1W',
      '-NvlGSeQl5gS75VuIIqr',
      '-NvlGwmSxN1TaA-HdBFl',
      '-NvlH2kk1ufkBDiGf69S',
      '-NvlHLVOsMP6ysk356PK',
      '-NvlH_WQArnWNpoU8vvR',
      '-NvlHkwwZh9N_FHdAj8e',
      '-NvlHukC7tC1zn3-r1UP',
      '-NvlIBGM22Sexin1FvgJ',
    ];

    for (String quizId in quizIds) {
      _userResultsRef
          .child(quizAttemptId)
          .child('quiz_results')
          .child(quizId)
          .set({
        'timestamp': DateTime.now().toString(),
        'score': score,
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: background,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                'Score: $score',
                                style: TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                            QuestionWidget(
                              indexAction: index,
                              question: extractedData[index].title,
                              totalQuestion: extractedData.length,
                              imageUrl: extractedData[index].imageUrl,
                            ),
                            const Divider(color: Colors.grey),
                            const SizedBox(height: 25.0),
                            for (int i = 0; i < extractedData[index].options.length; i++)
                              GestureDetector(
                                onTap: () =>
                                    checkAnswer(extractedData[index].options.values.toList()[i]),
                                child: OptionC(
                                  option: extractedData[index].options.keys.toList()[i],
                                  color: isPressed
                                      ? extractedData[index].options.values.toList()[i] == true
                                          ? correct
                                          : incorrect
                                      : neutral,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: button1(
                      nextQuestion: nextQuestion,
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Center(
          child: Text("No Data Available"),
        );
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      color: Color.fromARGB(255, 48, 48, 48),
      child: Center(
        child: Text(
          'Quiz 1',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final int indexAction;
  final String question;
  final int totalQuestion;
  final String imageUrl;

  const QuestionWidget({
    Key? key,
    required this.indexAction,
    required this.question,
    required this.totalQuestion,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl.isNotEmpty)
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey,
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        SizedBox(height: 10),
        Text(
          'Question ${indexAction + 1}/$totalQuestion: $question',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ],
    );
  }
}
Future<void> _InputButtonUserState(
  String userId,
  bool lesson1Pressed,
  bool lesson2Pressed,
  bool allowAccesstoQuiz1,
  bool allowAccesstoQuiz2,
  bool allowAccesstoQuiz3,
  bool allowAccesstoQuiz4,
  bool allowAccesstoQuiz5,
) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a PATCH request to update the boolean values for the user
    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({
        'lesson1Pressed': lesson1Pressed,
         'allowAccesstoQuiz1': allowAccesstoQuiz1,
         'lesson2Pressed': lesson2Pressed,
         'allowAccesstoQuiz2': allowAccesstoQuiz2,
         'allowAccesstoQuiz3': allowAccesstoQuiz3,
         'allowAccesstoQuiz4': allowAccesstoQuiz4,
         'allowAccesstoQuiz5': allowAccesstoQuiz5,
      }),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('Boolean values updated successfully for the current user in Firebase!');
    } else {
      print('Failed to update boolean values for the current user in Firebase: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating boolean values for the current user in Firebase: $error');
  }
}
