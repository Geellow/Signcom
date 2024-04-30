

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> SignupWithEmailAndPassword (String email, String password) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password,);
      return credential.user;
    } catch (e) {
      print("error occured");
    }
    return null;
  }

  Future<User?> SignInWithEmailAndPassword (String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print ("error occured: $e");
    }
    return null;
  }
  Future<bool> checkIfEmailExists(String email) async {
    try {
      // Attempt to create a temporary user with the given email and a random password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword', // Provide a temporary password
      );

      // If no error occurs, it means the email is not in use
      return false;
    } catch (e) {
      // If an error occurs, check if it's due to the email being already in use
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        return true;
      }
      // If the error is not due to the email being already in use, handle it accordingly
      print("Error occurred while checking email existence: $e");
      return false;
    }
  }
  Future<void> _showVerificationSentDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Verification Email Sent'),
        content: Text('A verification email has been sent to your email address.'),
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

// Function to show error dialog
Future<void> _showErrorDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text('An error occurred while sending the verification email. Please try again later.'),
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