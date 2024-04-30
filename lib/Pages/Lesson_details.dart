import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signcom/Pages/Lessons/Lesson_1.dart';
import 'package:signcom/Pages/Lessons/Lesson_2.dart';
import 'package:signcom/Pages/Lessons/Lesson_3.dart';
import 'package:signcom/Pages/Lessons/Lesson_4.dart';
import 'package:signcom/Pages/Lessons/Lesson_5.dart';

class LessonsDetailPage extends StatefulWidget {
  @override
  _LessonsDetailPageState createState() => _LessonsDetailPageState();
}

class _LessonsDetailPageState extends State<LessonsDetailPage> {
  bool AccesstoLesson1 = false;
  bool AccesstoLesson2 = false;
  bool AccesstoLesson3 = false;
  bool AccesstoLesson4 = false;
  bool AccesstoLesson5 = false;
  
  @override
  void initState() {
    super.initState();
    _InputButtonUserState();
  }
  Future<void> _InputButtonUserState() async {
  try {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Firebase Realtime Database URL for the current user's data
      final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

      // Make a GET request to fetch the user data
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        setState(() {
          AccesstoLesson1 = userData['lesson1Pressed'] ?? false;
          AccesstoLesson2 = userData['lesson2Pressed'] ?? false;
          AccesstoLesson3 = userData['lesson3Pressed'] ?? false;
          AccesstoLesson4 = userData['lesson4Pressed'] ?? false;
          AccesstoLesson5 = userData['lesson5Pressed'] ?? false;
        });
        
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } else {
      print('No user is currently signed in.');
    }
  } catch (error) {
    print('Error fetching user data: $error');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PressableRoundedCorner(
                label: 'Lesson 1: Basic Alphabetics Hand Sign',
                onPressed: () {
                  if (AccesstoLesson1) {
                  _showAlertDialog(context);
                } else {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lesson1()),
                  );
                }
                }
              ),
              SizedBox(height: 40),
              PressableRoundedCorner(
                label: 'Lesson 2: Basic Numbers Hand Sign',
                onPressed: () {
                  if (AccesstoLesson2) {
                  _showAlertDialog(context);
                } else {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lesson2()),
                  );
                }
                }
              ),
              SizedBox(height: 40),
              PressableRoundedCorner(
                label: 'Lesson 3: Greetings and Polite Expressions',
                onPressed: () {
                  if (AccesstoLesson3) {
                  _showAlertDialog(context);
                } else {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lesson3()),
                  );
                }
                }
              ),
              SizedBox(height: 40),
              PressableRoundedCorner(
                label: 'Lesson 4: Knowing About Oneself and Question Words',
                onPressed: () {
                  if (AccesstoLesson4) {
                  _showAlertDialog(context);
                } else {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lesson4()),
                  );
                }
                }
              ),
              SizedBox(height: 40),
              PressableRoundedCorner(
                label: 'Lesson 5: Pronouns in Sign Language',
                onPressed: () {
                  if (AccesstoLesson5) {
                  _showAlertDialog(context);
                } else {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lesson5()),
                  );
                }
                }
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;
  final Color iconColor;

  const BottomBarButton({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonWidth = displayWidth * 0.18;

    if (currentIndex == index) {
      buttonWidth = displayWidth * 0.32;
    }

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: buttonWidth,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: currentIndex == index ? displayWidth * 0.12 : 0,
              width: currentIndex == index ? displayWidth * 0.32 : 0,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: buttonWidth,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: displayWidth * 0.076,
              color: iconColor, // Use the original icon color
            ),
          ),
        ],
      ),
    );
  }
}

void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Access Denied'),
          content: Text('You havent finished or started a Quiz'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
class PressableRoundedCorner extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const PressableRoundedCorner({required this.label, required this.onPressed});

  @override
  _PressableRoundedCornerState createState() => _PressableRoundedCornerState();
}

class _PressableRoundedCornerState extends State<PressableRoundedCorner> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: Container(
        width: displayWidth * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1?.color,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth * 0.05,
          ),
        ),
      ),
    );
  }
}
