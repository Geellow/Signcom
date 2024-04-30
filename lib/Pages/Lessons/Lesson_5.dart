import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:signcom/Pages/Home.dart';

class Lesson5 extends StatefulWidget {
  const Lesson5({Key? key}) : super(key: key);

  @override
  State<Lesson5> createState() => _Lesson5State();
}

class _Lesson5State extends State<Lesson5> {
  bool lesson5Pressed = false;
  bool allowAccesstoQuiz5 = false;
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
                          text: 'Lesson 5 ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'of our sign language course! Today, we\'re delving into the fascinating world of pronouns in sign language. Pronouns play a crucial role in communication, allowing us to refer to ourselves, others, and objects efficiently.',
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
                  // Bullet points
                  _buildBulletPoint('Learning different types of pronouns, including personal pronouns'),
                  _buildBulletPoint('Mastering the appropriate use of pronouns to refer to oneself, others, and objects in various signing contexts'),
                  _buildBulletPoint('Applying pronouns effectively in conversations, narratives, and expressive signing to convey meaning accurately and respectfully'),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      // First Image
                      Image.asset(
                        'assets/Pronouns/Pronouns1.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),

                      // Second Image
                      Image.asset(
                        'assets/Pronouns/Pronouns2.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),

                      Image.asset(
                        'assets/Pronouns/Pronouns3.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),

                      Image.asset(
                        'assets/Pronouns/Pronouns4.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),

                      // Description of all images
                      Text(
                        'Pronouns in Sign Language',
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
                        lesson5Pressed =!lesson5Pressed;
                        allowAccesstoQuiz5 =!allowAccesstoQuiz5;
                        print(lesson5Pressed);
                        if (userId != null) {
                          _InputButtonUserState(userId!, lesson5Pressed, allowAccesstoQuiz5);
                        }
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
          content: Text('You have finished your Fifth lesson.'),
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
  bool lesson5Pressed,
  bool allowAccesstoQuiz5,
) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a PATCH request to update the boolean values for the user
    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({
        'lesson5Pressed': lesson5Pressed,
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