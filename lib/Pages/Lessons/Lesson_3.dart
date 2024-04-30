import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:signcom/Pages/Home.dart';

class Lesson3 extends StatefulWidget {
  const Lesson3({Key? key}) : super(key: key);

  @override
  State<Lesson3> createState() => _Lesson3State();
}

class _Lesson3State extends State<Lesson3> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitializing = true;
  bool allowAccesstoQuiz3 = false;
  String? userId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideoController();
    });
    fetchUserId();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoController() async {
    _controller = VideoPlayerController.asset(
      'assets/Greetings/GreetingsVideo1.mp4',
    );
    await _controller.initialize();
    setState(() {
      _isInitializing = false;
    });
  }

  void _loadVideo(String videoAsset) async {
    await _controller.pause();
    await _controller.seekTo(Duration.zero);
    setState(() {
      _isInitializing = true;
    });
    _controller = VideoPlayerController.asset(
      videoAsset,
    );
    await _controller.initialize();
    setState(() {
      _isInitializing = false;
    });
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
                          text: 'Lesson 3 ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'of our sign language course! Today, we\'re focusing on understanding gestures and using polite expressions in sign language. Gestures convey emotions that enhance communication, while polite expressions ensure respectful interactions. Are you ready to learn a new way to express yourself?',
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
                  _buildBulletPoint('Learning different gestures and polite ways to express them'),
                  _buildBulletPoint('Mastering polite expressions for respectful communication'),
                  _buildBulletPoint('Practice exercises to reinforce understanding'),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Image.asset(
                        'assets/Greetings/Greetings1.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/Greetings/Greetings2.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/Greetings/Greetings3.jpg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/Greetings/Greetings4.jpg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Greetings and Polite Expressions in Sign Language',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _isInitializing
                      ? CircularProgressIndicator()
                      : AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPlaying ? _controller.pause() : _controller.play();
                                _isPlaying = !_isPlaying;
                              });
                            },
                            child: VideoPlayer(_controller),
                          ),
                        ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _loadVideo('assets/Greetings/GreetingsVideo1.mp4');
                        },
                        child: Text('Video 1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _loadVideo('assets/Greetings/GreetingsVideo2.mp4');
                        },
                        child: Text('Video 2'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _loadVideo('assets/Greetings/GreetingsVideo3.mp4');
                        },
                        child: Text('Video 3'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                    ElevatedButton(
                     onPressed: () {
                      _showCongratulationsDialog(context);
                       setState(() {
                        allowAccesstoQuiz3 =!allowAccesstoQuiz3;
                        if (userId != null) {
                          _InputButtonUserState(userId!, allowAccesstoQuiz3);
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
                  SizedBox(height: 20), // Add space here
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
          content: Text('You have finished your Third lesson.'),
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
  bool allowAccesstoQuiz3,
) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a PATCH request to update the boolean values for the user
    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({
        'allowAccesstoQuiz3': allowAccesstoQuiz3,
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