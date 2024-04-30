import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signcom/User_Login/Login_Form.dart'; // Assuming LoginForm.dart contains the login form widget

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 26, 26, 1), // Same as login form
        title: Text('Verify Email'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set back button icon and color
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginForm()), // Go back to the login form
            );
          },
        ),
      ),
      body: Container(
        color: Color.fromRGBO(21, 20, 21, 1), // Set background color
        child: Center(
          child: isEmailVerified
              ? LoginForm() // Navigate to the login form if email is verified
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A verification email has been sent to your email address.',
                      style: TextStyle(color: Colors.white), // Same as login form
                    ),
                    SizedBox(height: 20), // Add space between text and button
                    ElevatedButton(
                      onPressed: () async {
                        // Resend verification email
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await user.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Verification email resent')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 255, 163, 1), // Background color
                        onPrimary: Colors.black, // Text color
                      ),
                      child: Text('Resend Verification Email'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
