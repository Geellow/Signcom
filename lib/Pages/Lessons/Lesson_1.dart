import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signcom/Pages/Home.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Lesson1 extends StatefulWidget {
  const Lesson1({Key? key}) : super(key: key);

  @override
  State<Lesson1> createState() => _Lesson1State();
}

class _Lesson1State extends State<Lesson1> {
  late VideoPlayerController _controller;
  bool lesson1Pressed = false;
   bool allowAccesstoQuiz1 = false;
  String? userId;
  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    fetchUserId();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _initializeVideoController() async {
    _controller = VideoPlayerController.asset(
      'assets/Letters/AlphabeticsVideo.mp4',
    );
    await _controller.initialize();
    setState(() {});
  }

  Future<void> fetchUserId() async {
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
                          text: 'Lesson 1 ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'of our sign language course! Today, we\'re diving into the world of basic alphabetic hand signs. Just like spoken languages have their own alphabet, sign language does too. But instead of letters, we communicate with our hands. Are you ready to learn a new way to express yourself?',
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
                  _buildBulletPoint('Introduction to the manual alphabet'),
                  _buildBulletPoint('Learning the handshapes for each letter'),
                  _buildBulletPoint('Practice exercises to reinforce understanding'),
                  _buildBulletPoint('Importance of clear and precise hand movements'),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Image.asset(
                        'assets/alphabetics.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Alphabetics in Sign Language',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : CircularProgressIndicator(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showCongratulationsDialog(context);
                       setState(() {
                        lesson1Pressed =!lesson1Pressed;
                        allowAccesstoQuiz1 =!allowAccesstoQuiz1;
                        print(lesson1Pressed);
                        if (userId != null) {
                          _InputButtonUserState(userId!, lesson1Pressed, allowAccesstoQuiz1);
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

  void _showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have finished your First lesson.'),
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
}

 Future<void> _InputButtonUserState(
  String userId,
  bool lesson1Pressed,
   bool allowAccesstoQuiz1,
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