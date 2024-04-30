import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromRGBO(21, 20, 21, 1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(26, 26, 26, 1),
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
        ),
      ),
      home: ForgotVerificationPage(),
    );
  }
}

class ForgotVerificationPage extends StatelessWidget {
  const ForgotVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Verification'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter your email to resend verification',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            EmailInput(
              emailController: _emailController,
              onEmailChanged: (email) {
                // Handle email change
                print("Entered email: $email");
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Get the entered email address from the EmailInput widget
                String email = _emailController.text.trim();

                // Check if email is not empty
                if (email.isNotEmpty) {
                  try {
                    // Get the current user
                    User? user = FirebaseAuth.instance.currentUser;

                    // Send email verification to the provided email address
                    await user!.sendEmailVerification();

                    // Show a confirmation message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Verification email sent to $email'),
                      ),
                    );
                  } catch (e) {
                    // Show an error message if sending email verification fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to send verification email'),
                      ),
                    );
                    print('Error sending verification email: $e');
                  }
                } else {
                  // Show an error message if the email field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your email'),
                    ),
                  );
                }
              },
              child: Text('Resend Verification'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatefulWidget {
  final ValueChanged<String> onEmailChanged;
  final TextEditingController emailController;

  const EmailInput({Key? key, required this.onEmailChanged, required this.emailController}) : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.emailController,
      style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color!),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color!),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onChanged: widget.onEmailChanged,
    );
  }
}
