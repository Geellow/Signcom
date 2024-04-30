import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
    _navigateNextScreen();
    });
  }

  _navigateNextScreen() {
      try {
    if (FirebaseAuth.instance.currentUser != null) {
      print('User authenticated. Navigating to home...');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('User not authenticated. Navigating to login...');
      Navigator.pushReplacementNamed(context, '/login');
    }
  } catch (e) {
    print('Error during Navigation: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logo2.png'),
              width: 100.0,
              height: 100.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Signcom',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            SizedBox(height: 24.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

