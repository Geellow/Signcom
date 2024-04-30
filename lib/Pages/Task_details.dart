import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signcom/Pages/Quiz/Quiz1.dart';
import 'package:signcom/Pages/Quiz/Quiz2.dart';
import 'package:signcom/Pages/Quiz/Quiz3.dart';
import 'package:signcom/Pages/Quiz/Quiz4.dart';
import 'package:signcom/Pages/Quiz/Quiz5.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskDetailPage extends StatefulWidget {
  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  bool allowAccesstoQuiz1 = false;
  bool allowAccesstoQuiz2 = false;
  bool allowAccesstoQuiz3 = false;
  bool allowAccesstoQuiz4 = false;
  bool allowAccesstoQuiz5 = false;
  
  bool lesson1Pressed = false;
  bool lesson2Pressed = false;
  bool lesson3Pressed = false;
  bool lesson4Pressed = false;
  bool lesson5Pressed = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _InputButtonUserState();
    _fetchUserId();
  }
  Future<void> _fetchUserId () async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
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
          allowAccesstoQuiz1 = userData['allowAccesstoQuiz1'] ?? false;
          allowAccesstoQuiz2 = userData['allowAccesstoQuiz2'] ?? false;
          allowAccesstoQuiz3 = userData['allowAccesstoQuiz3'] ?? false;
          allowAccesstoQuiz4 = userData['allowAccesstoQuiz4'] ?? false;
          allowAccesstoQuiz5 = userData['allowAccesstoQuiz5'] ?? false;
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PressableRoundedCorner(
                  label: 'Quiz 1: Basic Alphabetics',
                  onPressed: () {
                    if (allowAccesstoQuiz1) {
  // Check if the other quiz access flags are already true,
  // and if so, don't change their values
  bool AllowAccessToQuiz2 = allowAccesstoQuiz2;
  bool AllowAccessToQuiz3 = allowAccesstoQuiz3;
  bool AllowAccessToQuiz4 = allowAccesstoQuiz4;
  bool AllowAccesstoQuiz5 = allowAccesstoQuiz5;


  // Only update the other quiz access flags if they are currently true

  if (allowAccesstoQuiz2) {
    allowAccesstoQuiz2 = !AllowAccessToQuiz2;
  }
  if (allowAccesstoQuiz3) {
    allowAccesstoQuiz3 = !AllowAccessToQuiz3;
  }
  if (allowAccesstoQuiz4) {
    allowAccesstoQuiz4 = !AllowAccessToQuiz4;
  }
  if (allowAccesstoQuiz5) {
    allowAccesstoQuiz5 = !AllowAccesstoQuiz5;
  }


  allowAccesstoQuiz1 = true;

  setState(() {
    lesson1Pressed != lesson1Pressed;
    lesson2Pressed != lesson2Pressed;
    lesson3Pressed != lesson3Pressed;
    lesson4Pressed != lesson4Pressed;
    lesson5Pressed != lesson5Pressed;
    _InputButtonUserState2(
      userId!,
      lesson1Pressed,
      lesson2Pressed,
      allowAccesstoQuiz1,
      allowAccesstoQuiz2,
      lesson3Pressed,
      allowAccesstoQuiz3,
      lesson4Pressed,
      allowAccesstoQuiz4,
      lesson5Pressed,
      allowAccesstoQuiz5,
    );
  });
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Quiz_1()),
  );
} else {
  _showAlertDialog(context);
}
                  },
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PressableRoundedCorner(
                  label: 'Quiz 2: Basic Numbers',
                  onPressed: () {
                    if (allowAccesstoQuiz2) {
  // Check if the other quiz access flags are already true,
  // and if so, don't change their values
  bool AllowAccessToQuiz1 = allowAccesstoQuiz1;
  bool AllowAccessToQuiz3 = allowAccesstoQuiz3;
  bool AllowAccessToQuiz4 = allowAccesstoQuiz4;
  bool AllowAccessToQuiz5 = allowAccesstoQuiz5;


  // Only update the other quiz access flags if they are currently true
  if (allowAccesstoQuiz1) {
    allowAccesstoQuiz1 = !AllowAccessToQuiz1;
  }

  if (allowAccesstoQuiz3) {
    allowAccesstoQuiz3 = !AllowAccessToQuiz3;
  }
  if (allowAccesstoQuiz4) {
    allowAccesstoQuiz4 = !AllowAccessToQuiz4;
  }
  if (allowAccesstoQuiz5) {
    allowAccesstoQuiz5 = !AllowAccessToQuiz5;
  }

  allowAccesstoQuiz2 = true;
 
  setState(() {
    lesson1Pressed != lesson1Pressed;
    lesson2Pressed != lesson2Pressed;
    lesson3Pressed != lesson3Pressed;
    lesson4Pressed != lesson4Pressed;
    lesson5Pressed != lesson5Pressed;
    _InputButtonUserState2(
      userId!,
      lesson1Pressed,
      lesson2Pressed,
      allowAccesstoQuiz1,
      allowAccesstoQuiz2,
      lesson3Pressed,
      allowAccesstoQuiz3,
      lesson4Pressed,
      allowAccesstoQuiz4,
      lesson5Pressed,
      allowAccesstoQuiz5,
    );
  });
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Quiz_2()),
  );
} else {
  _showAlertDialog(context);
}
                  },
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PressableRoundedCorner(
                  label: 'Quiz 3: Greetings and Polite Expressions',
                  onPressed: () {
                    if (allowAccesstoQuiz3) {
  // Check if the other quiz access flags are already true,
  // and if so, don't change their values
  bool AllowAccessToQuiz1 = allowAccesstoQuiz1;
  bool AllowAccessToQuiz2 = allowAccesstoQuiz2;
  bool AllowAccessToQuiz4 = allowAccesstoQuiz4;
  bool AllowAccessToQuiz5 = allowAccesstoQuiz5;


  // Only update the other quiz access flags if they are currently true
  if (allowAccesstoQuiz1) {
    allowAccesstoQuiz1 = !AllowAccessToQuiz1;
  }
  if (allowAccesstoQuiz2) {
    allowAccesstoQuiz2 = !AllowAccessToQuiz2;
  }
  if (allowAccesstoQuiz4) {
    allowAccesstoQuiz4 = !AllowAccessToQuiz4;
  }
  if (allowAccesstoQuiz5) {
    allowAccesstoQuiz5 = !AllowAccessToQuiz5;
  }


  allowAccesstoQuiz3 = true;
 
  setState(() {
    lesson1Pressed != lesson1Pressed;
    lesson2Pressed != lesson2Pressed;
    lesson3Pressed != lesson3Pressed;
    lesson4Pressed != lesson4Pressed;
    lesson5Pressed != lesson5Pressed;
    _InputButtonUserState2(
      userId!,
      lesson1Pressed,
      lesson2Pressed,
      allowAccesstoQuiz1,
      allowAccesstoQuiz2,
      lesson3Pressed,
      allowAccesstoQuiz3,
      lesson4Pressed,
      allowAccesstoQuiz4,
      lesson5Pressed,
      allowAccesstoQuiz5,
    );
  });
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Quiz_3()),
  );
} else {
  _showAlertDialog(context);
}
                  },
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PressableRoundedCorner(
                  label: 'Quiz 4: Knowing About Oneself and Question Words',
                  onPressed: () {
                    if (allowAccesstoQuiz4) {
  // Check if the other quiz access flags are already true,
  // and if so, don't change their values
  bool AllowAccessToQuiz1 = allowAccesstoQuiz1;
  bool AllowAccessToQuiz2 = allowAccesstoQuiz2;
  bool AllowAccessToQuiz3 = allowAccesstoQuiz3;
  bool AllowAccessToQuiz5 = allowAccesstoQuiz5;


  // Only update the other quiz access flags if they are currently true
  if (allowAccesstoQuiz1) {
    allowAccesstoQuiz1 = !AllowAccessToQuiz1;
  }
  if (allowAccesstoQuiz2) {
    allowAccesstoQuiz2 = !AllowAccessToQuiz2;
  }
  if (allowAccesstoQuiz3) {
    allowAccesstoQuiz3 = !AllowAccessToQuiz3;
  }
  if (allowAccesstoQuiz5) {
    allowAccesstoQuiz5 = !AllowAccessToQuiz5;
  }



  allowAccesstoQuiz4 = true;

  setState(() {
    lesson1Pressed != lesson1Pressed;
    lesson2Pressed != lesson2Pressed;
    lesson3Pressed != lesson3Pressed;
    lesson4Pressed != lesson4Pressed;
    lesson5Pressed != lesson5Pressed;
    _InputButtonUserState2(
      userId!,
      lesson1Pressed,
      lesson2Pressed,
      allowAccesstoQuiz1,
      allowAccesstoQuiz2,
      lesson3Pressed,
      allowAccesstoQuiz3,
      lesson4Pressed,
      allowAccesstoQuiz4,
      lesson5Pressed,
      allowAccesstoQuiz5,
    );
  });
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Quiz_4()),
  );
} else {
  _showAlertDialog(context);
}
                  },
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PressableRoundedCorner(
                  label: 'Quiz 5: Pronouns',
                  onPressed: () {
                    if (allowAccesstoQuiz5) {
  // Check if the other quiz access flags are already true,
  // and if so, don't change their values
  bool AllowAccessToQuiz1 = allowAccesstoQuiz1;
  bool AllowAccessToQuiz2 = allowAccesstoQuiz2;
  bool AllowAccessToQuiz3 = allowAccesstoQuiz3;
  bool AllowAccessToQuiz4 = allowAccesstoQuiz4;


  // Only update the other quiz access flags if they are currently true
  if (allowAccesstoQuiz1) {
    allowAccesstoQuiz1 = !AllowAccessToQuiz1;
  }
  if (allowAccesstoQuiz2) {
    allowAccesstoQuiz2 = !AllowAccessToQuiz2;
  }
  if (allowAccesstoQuiz3) {
    allowAccesstoQuiz3 = !AllowAccessToQuiz3;
  }
  if (allowAccesstoQuiz4) {
    allowAccesstoQuiz4 = !AllowAccessToQuiz4;
  }


  allowAccesstoQuiz5 = true;

  setState(() {
    lesson1Pressed != lesson1Pressed;
    lesson2Pressed != lesson2Pressed;
    lesson3Pressed != lesson3Pressed;
    lesson4Pressed != lesson4Pressed;
    lesson5Pressed != lesson5Pressed;
    _InputButtonUserState2(
      userId!,
      lesson1Pressed,
      lesson2Pressed,
      allowAccesstoQuiz1,
      allowAccesstoQuiz2,
      lesson3Pressed,
      allowAccesstoQuiz3,
      lesson4Pressed,
      allowAccesstoQuiz4,
      lesson5Pressed,
      allowAccesstoQuiz5,
    );
  });
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Quiz_5()),
  );
} else {
  _showAlertDialog(context);
}
                  },
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
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
          content: Text('You need to finish Lesson before accessing Quiz.'),
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
class PressableRoundedCorner extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PressableRoundedCorner({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(20),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontWeight: FontWeight.bold,
                fontSize: displayWidth * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _InputButtonUserState2(
  String userId,
  bool lesson1Pressed,
  bool lesson2Pressed,
  bool allowAccesstoQuiz1,
  bool allowAccesstoQuiz2,
  bool lesson3Pressed,
  bool allowAccesstoQuiz3,
  bool lesson4Pressed,
  bool allowAccesstoQuiz4,
  bool lesson5Pressed,
  bool allowAccesstoQuiz5,
) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a GET request to fetch the user data
    final response = await http.get(Uri.parse(url));

    // Check if the request was successful
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);

      // Update lessonPressed values to true if they are false
      if (!lesson1Pressed && userData['lesson1Pressed'] == false) {
        lesson1Pressed = true;
      }
      if (!lesson2Pressed && userData['lesson2Pressed'] == false) {
        lesson2Pressed = true;
      }
      if (!lesson3Pressed && userData['lesson3Pressed'] == false) {
        lesson3Pressed = true;
      }
      if (!lesson4Pressed && userData['lesson4Pressed'] == false) {
        lesson4Pressed = true;
      }
      if (!lesson5Pressed && userData['lesson5Pressed'] == false) {
        lesson5Pressed = true;
      }

      // Make a PATCH request to update the boolean values for the user
      final updateResponse = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'lesson1Pressed': lesson1Pressed || userData['lesson1Pressed'] == true,
          'allowAccesstoQuiz1': allowAccesstoQuiz1,
          'lesson2Pressed': lesson2Pressed || userData['lesson2Pressed'] == true,
          'allowAccesstoQuiz2': allowAccesstoQuiz2,
          'allowAccesstoQuiz3': allowAccesstoQuiz3,
          'lesson3Pressed': lesson3Pressed || userData['lesson3Pressed'] == true,
          'lesson4Pressed': lesson4Pressed || userData['lesson4Pressed'] == true,
          'allowAccesstoQuiz4': allowAccesstoQuiz4,
          'lesson5Pressed': lesson5Pressed || userData['lesson5Pressed'] == true,
          'allowAccesstoQuiz5': allowAccesstoQuiz5,
        }),
      );

      // Check if the update request was successful
      if (updateResponse.statusCode == 200) {
        print('Boolean values updated successfully for the current user in Firebase!');
      } else {
        print('Failed to update boolean values for the current user in Firebase: ${updateResponse.statusCode}');
      }
    } else {
      print('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating boolean values for the current user in Firebase: $error');
  }
}

