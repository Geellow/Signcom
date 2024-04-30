import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:signcom/Pages/Home.dart';

class Lesson4 extends StatefulWidget {
  const Lesson4({Key? key}) : super(key: key);

  @override
  State<Lesson4> createState() => _Lesson4State();
}

class _Lesson4State extends State<Lesson4> {
  bool allowAccesstoQuiz4 = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }
  Future<void> fetchUserId () async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/logo2.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: 'Lesson 4 ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'of our sign language course! Today, we\'re focusing on understanding knowing others or oneself in sign language. Sign language isn\'t just about communicating with others, it\'s also a powerful tool for self-expression. Are you ready on a journey of self-discovery?',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'In this lesson, we\'ll explore these main areas:',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildBulletPoint('Learning different gestures to understand or know others or about oneself'),
                  _buildBulletPoint('Mastering knowing about oneself gestures for respectful communication'),
                  _buildBulletPoint('Practice exercises to reinforce understanding'),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Image.asset(
                        'assets/Know/Knowing1.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/Know/Knowing2.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/Know/Question1.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/Know/Question2.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Knowing About Oneself and Question Words in Sign Language',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showCongratulationsDialog(context);
                       setState(() {
                        allowAccesstoQuiz4 =!allowAccesstoQuiz4;
                        _InputButtonUserState(userId!, allowAccesstoQuiz4);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text('Finish Lesson'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
void _showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have finished your Fourth lesson.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
Future<void> _InputButtonUserState(
  String userId,
  bool allowAccesstoQuiz4,
) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a PATCH request to update the boolean values for the user
    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({
        'allowAccesstoQuiz4': allowAccesstoQuiz4,
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