import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:signcom/Pages/Home.dart';
import 'package:signcom/Pages/Quiz/Quiz_layout/Questionares.dart';
import 'package:signcom/Quiz_Database/Quiz_Database5.dart';
import 'package:signcom/User_Login/Login_Form.dart';
import 'package:signcom/User_Login/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase has already been initialized
  if (Firebase.apps.isEmpty) {
    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyAnGgct6_zE6sL9Wuwcn_rAC3Ag5M9Fa-I',
          appId: '1:657634229937:android:0ab8f4b73a68f3f9deac90',
          messagingSenderId: '657634229937',
          projectId: 'signcom-official',
          storageBucket: 'gs://signcom-official.appspot.com',
        ),
      );
    } catch (e) {
      print('Failed to initialize Firebase: $e');
    }
  } else {
    print('Firebase is already initialized');
  }

  var db = DBconnect5();
  db.fetchQuestion();
  db.addQuestion(Question(
    id: '154',
    title: 'Identify The Pronouns in the Photo',
    options: {'Ourselves': false, 'Themselves': false, 'Yourselves': false, 'Itself':true},
    imageUrl: 'assets/Pronouns/ITSELF.jpeg'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light().copyWith(
              // Customize light mode colors here
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.white,
              colorScheme: ColorScheme.light(
                primary: const Color.fromRGBO(144,112,255,1),
                secondary: const Color.fromRGBO(144,112,255,1),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(144,112,255,1), // Violet button color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              // Customize dark mode colors here
              scaffoldBackgroundColor: Colors.grey[900],
              primaryColor: Colors.grey[900],
              colorScheme: ColorScheme.dark(
                primary: const Color.fromRGBO(144,112,255,1),
                secondary: const Color.fromRGBO(144,112,255,1),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(144,112,255,1), // Violet button color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            home: AuthWrapper(),
            routes: {
              '/SplashScreen': (context) => SplashScreen(),
              '/home': (context) => HomePage(),
              '/login': (context) => LoginForm(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        }
        if (snapshot.hasError) {
          return Scaffold(body: Text(snapshot.error.toString()));
        }
        return SplashScreen();
      },
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
