import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:signcom/Pages/Account_details.dart';
import 'package:signcom/Pages/Lesson_details.dart';
import 'package:signcom/Pages/Task_details.dart';
import 'package:signcom/User_Login/Login_Form.dart';
import 'package:signcom/main.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  var currentIndex = 0;
  late User _currentUser; // Declare currentUser variable
  bool _isNewUser = true; // Check if user is new or existing
  late VideoPlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _controller = VideoPlayerController.asset(
      'assets/SignCom.mp4',
    )..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video player: $error');
      });

    // Check if the user is already authenticated
    _checkCurrentUser();
  }

  void _checkCurrentUser() async {
    // Retrieve the current user asynchronously
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is already signed in
    if (user != null) {
      setState(() {
        _currentUser = user;
        _isNewUser = _currentUser.metadata.creationTime ==
            _currentUser.metadata.lastSignInTime;
      });
    } else {
      // The user is not signed in, navigate to the login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginForm()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    Color iconColor = Colors.black;
    Color textColor = Colors.black;

    if (Theme.of(context).brightness == Brightness.dark) {
      iconColor = Colors.white;
      textColor = Colors.white;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              _toggleTheme(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentIndex == 0)
              _buildHomePageContent(displayWidth, iconColor, textColor),
            SizedBox(height: 20),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  // Prevent further scroll when reaching the end of content
                  return true;
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    children: [
                      HomeDetailPage(),
                      LessonsDetailPage(),
                      TaskDetailPage(),
                      AccountDetailPage(
                        currentUser: _currentUser,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(displayWidth * 0.05),
        height: displayWidth * 0.2,
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarButton(
              icon: Icons.home_rounded,
              index: 0,
              currentIndex: currentIndex,
              onTap: (index) {
                handleNavigation(index);
              },
              iconColor: iconColor,
            ),
            BottomBarButton(
              icon: Icons.menu_book_rounded,
              index: 1,
              currentIndex: currentIndex,
              onTap: (index) {
                handleNavigation(index);
              },
              iconColor: iconColor,
            ),
            BottomBarButton(
              icon: Icons.assignment_rounded,
              index: 2,
              currentIndex: currentIndex,
              onTap: (index) {
                handleNavigation(index);
              },
              iconColor: iconColor,
            ),
            BottomBarButton(
              icon: Icons.person_rounded,
              index: 3,
              currentIndex: currentIndex,
              onTap: (index) {
                handleNavigation(index);
              },
              iconColor: iconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePageContent(double displayWidth, Color iconColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isNewUser
                ? "Welcome to SignCom:\nConnect"
                : "Welcome back to SignCom:\nConnect",
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Text(
            "ABOUT SIGNCOM: CONNECT",
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "SignCom is a sign language learning mobile application designed to help you learn sign language efficiently. With interactive lessons, quizzes, and practice sessions, you can improve your sign language skills at your own pace.",
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "In SignCom: Connect you can",
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chrome_reader_mode_rounded,
                      size: 40,
                      color: iconColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Read",
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 40,
                      color: iconColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Learn",
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_rounded,
                      size: 40,
                      color: iconColor,
                    ),
                    Text(
                      "Test your",
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      "knowledge",
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "KNOW MORE ABOUT SIGNCOM: CONNECT",
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              GestureDetector(
                onTap: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                child: Container(
                  height: 300, // Adjust the height according to your preference
                  width: displayWidth * 0.9, // Adjust the width according to your preference
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: iconColor,
                ),
                onPressed: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    _controller.setVolume(_isMuted ? 0 : 1);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}

class BottomBarButton extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function onTap;
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
                    ? Theme.of(context).colorScheme.secondary
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

void _toggleTheme(BuildContext context) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  themeProvider.toggleTheme();
}

class HomeDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
