import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:signcom/User_Login/Forgot_password.dart';
import 'package:signcom/User_Login/Email_verify2.dart';
import 'package:signcom/User_Login/Register_Form.dart';
import 'package:signcom/main.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isObscure = true;
  bool lesson1Pressed = false;
  bool lesson2Pressed = true;
  bool lesson3Pressed = true;
  bool lesson4Pressed = true;
  bool lesson5Pressed = true;

  bool allowAccesstoQuiz1 = false;
  bool allowAccesstoQuiz2 = false;
  bool allowAccesstoQuiz3 = false;
  bool allowAccesstoQuiz4 = false;
  bool allowAccesstoQuiz5 = false;
  void _toggleTheme(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a GET request to fetch the user data
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response JSON
      final userData = json.decode(response.body);
      return userData != null ? userData : {};
    } else {
      print('Failed to fetch user data from Firebase: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error fetching user data from Firebase: $error');
    return {};
  }
}

Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null && userCredential.user!.emailVerified) {
      String userId = userCredential.user!.uid;

      // Fetch existing Data from the database
      Map<String, dynamic> userData = await _fetchUserData(userId);

      // Use the fetched data to update state variables
      setState(() {
        lesson1Pressed = userData['lesson1Pressed'] ?? lesson1Pressed;
        lesson2Pressed = userData['lesson2Pressed'] ?? lesson2Pressed;
        lesson3Pressed = userData['lesson3Pressed'] ?? lesson3Pressed;
        lesson4Pressed = userData['lesson4Pressed'] ?? lesson4Pressed;
        lesson5Pressed = userData['lesson5Pressed'] ?? lesson5Pressed;

        allowAccesstoQuiz1 = userData['allowAccesstoQuiz1'] ?? allowAccesstoQuiz1;
        allowAccesstoQuiz2 = userData['allowAccesstoQuiz2'] ?? allowAccesstoQuiz2;
        allowAccesstoQuiz3 = userData['allowAccesstoQuiz3'] ?? allowAccesstoQuiz3;
        allowAccesstoQuiz4 = userData['allowAccesstoQuiz4'] ?? allowAccesstoQuiz4;
        allowAccesstoQuiz5 = userData['allowAccesstoQuiz5'] ?? allowAccesstoQuiz5;
      });

      // If user data is null, treat it as a new user and create new data
      if (userData.isEmpty) {
        await _updateUserData(
          userId,
          lesson1Pressed,
          lesson2Pressed,
          lesson3Pressed,
          lesson4Pressed,
          lesson5Pressed,
          allowAccesstoQuiz1,
          allowAccesstoQuiz2,
          allowAccesstoQuiz3,
          allowAccesstoQuiz4,
          allowAccesstoQuiz5,
        );
      }

      Navigator.pushReplacementNamed(context, '/home');
      
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Not Verified'),
            content: Text('Your email is not verified. Please check your email for verification.'),
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
  } catch (e) {
    print('Failed to sign in: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to sign in. Please check your email and password.'),
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
}
Future<void> _updateUserData(
    String userId,
    bool lesson1Pressed,
    bool lesson2Pressed,
    bool lesson3Pressed,
    bool lesson4Pressed,
    bool lesson5Pressed,
    bool allowAccesstoQuiz1,
    bool allowAccesstoQuiz2,
    bool allowAccesstoQuiz3,
    bool allowAccesstoQuiz4,
    bool allowAccesstoQuiz5,
  ) async {
    try {
      // Firebase Realtime Database URL for the current user's data
      final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

      // Data to be stored in the database
      Map<String, dynamic> userData = {
        'lesson1Pressed': lesson1Pressed,
        'lesson2Pressed': lesson2Pressed,
        'lesson3Pressed': lesson3Pressed,
        'lesson4Pressed': lesson4Pressed,
        'lesson5Pressed': lesson5Pressed,
        'allowAccesstoQuiz1': allowAccesstoQuiz1,
        'allowAccesstoQuiz2': allowAccesstoQuiz2,
        'allowAccesstoQuiz3': allowAccesstoQuiz3,
        'allowAccesstoQuiz4': allowAccesstoQuiz4,
        'allowAccesstoQuiz5': allowAccesstoQuiz5,
      };

      // Make a PUT request to update user data in Firebase
      final response = await http.put(Uri.parse(url), body: json.encode(userData));

      if (response.statusCode == 200) {
        print('User data updated successfully.');
      } else {
        print('Failed to update user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SignCom',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: () {
            _toggleTheme(context); // Toggle theme when the icon is pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Image(
                image: AssetImage('assets/logo2.png'),
                width: 100.0,
                height: 120.0,
              ),
              SizedBox(height: 16.0),
              TextField(
                key: Key('emailField'),
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                key: Key('passwordField'),
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                obscureText: _isObscure,
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                    ),
                  ),
                  SizedBox(width: 105),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotVerificationPage()),
                      );
                    },
                    child: Text(
                      'Verification',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  signInWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegisterForm()),
                  );
                },
                child: Text('Create New Account'),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _InputButtonUserState(
  String userId,
  bool lesson1Pressed,
  bool lesson2Pressed,
  bool lesson3Pressed,
  bool lesson4Pressed,
  bool lesson5Pressed,

  bool allowAccesstoQuiz1,
  bool allowAccesstoQuiz2,
  bool allowAccesstoQuiz3,
  bool allowAccesstoQuiz4,
  bool allowAccesstoQuiz5,
) async {
  try {
    // Firebase Realtime Database URL for the current user's data
    final url = 'https://signcom-official-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    // Make a GET request to fetch the user data
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response JSON
      final userData = json.decode(response.body);

      if (userData != null) {
        // Use the fetched data to initialize the variables
        lesson1Pressed = userData['lesson1Pressed'] ?? lesson1Pressed;
        lesson2Pressed = userData['lesson2Pressed'] ?? lesson2Pressed;
        lesson3Pressed = userData['lesson3Pressed'] ?? lesson3Pressed;
        lesson4Pressed = userData['lesson4Pressed'] ?? lesson4Pressed;
        lesson5Pressed = userData['lesson5Pressed'] ?? lesson5Pressed;

        allowAccesstoQuiz1 = userData['allowAccesstoQuiz1'] ?? allowAccesstoQuiz1;
        allowAccesstoQuiz2 = userData['allowAccesstoQuiz2'] ?? allowAccesstoQuiz2;
        allowAccesstoQuiz3 = userData['allowAccesstoQuiz3'] ?? allowAccesstoQuiz3;
        allowAccesstoQuiz4 = userData['allowAccesstoQuiz4'] ?? allowAccesstoQuiz4;
        allowAccesstoQuiz5 = userData['allowAccesstoQuiz5'] ?? allowAccesstoQuiz5;
      } else {
        print('User data is null, setting default values.');

        // Set default values for the user's data
        lesson1Pressed = false;
        lesson2Pressed = true;
        lesson3Pressed = true;
        lesson4Pressed = true;
        lesson5Pressed = true;

        allowAccesstoQuiz1 = false;
        allowAccesstoQuiz2 = false;
        allowAccesstoQuiz3 = false;
        allowAccesstoQuiz4 = false;
        allowAccesstoQuiz5 = false;
      }
    } else {
      print('Failed to fetch user data from Firebase: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching user data from Firebase: $error');
  }
}

