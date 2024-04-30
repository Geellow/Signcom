import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signcom/User_Login/Login_Form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountDetailPage extends StatefulWidget {
  final User currentUser;

  const AccountDetailPage({required this.currentUser});

  @override
  _AccountDetailPageState createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  File? _imageFile;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _profilePictureUrl = '';


  @override
  void initState() {
    super.initState();
    _emailController.text = widget.currentUser.email ?? "";
    _loadProfilePicture();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _saveImageToFirebaseStorage(File imageFile) async {
    try {
      String fileName = '${widget.currentUser.uid}.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child(fileName);
      await storageRef.putFile(imageFile);
      String downloadUrl = await storageRef.getDownloadURL();
      addUserToFirestore(widget.currentUser.uid, widget.currentUser.email ?? "", downloadUrl);
    } catch (error) {
      print('Failed to save image to Firebase Storage: $error');
    }
  }

  Future<void> _saveImage() async {
    if (_imageFile != null) {
      _saveImageToFirebaseStorage(_imageFile!);
    }
  }

  Future<void> _requestEmailChange(String newEmail) async {
    print('Requesting email change to: $newEmail');
  }

  Future<void> _changePassword(String newPassword) async {
    print('Changing password to: $newPassword');
  }

  Future<void> _loadProfilePicture() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUser.uid)
          .get();
      final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          _profilePictureUrl = data['profile_picture'] ?? '';
        });
      }
    } catch (error) {
      print('Failed to load profile picture from Firestore: $error');
    }
  }

  Future<void> addUserToFirestore(String userId, String email, String profilePictureUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'profile_picture': profilePictureUrl,
      });
      print('User added to Firestore');
    } catch (error) {
      print('Failed to add user to Firestore: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_profilePictureUrl.isNotEmpty
                              ? NetworkImage(_profilePictureUrl)
                              : AssetImage('assets/placeholder.png') as ImageProvider),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveImage,
                icon: Icon(Icons.save, size: 20),
                label: Text('Save Image', style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email: ${widget.currentUser.email}',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      _emailController.text = widget.currentUser.email ?? "";
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Request Email Change'),
                            content: TextField(
                              controller: _emailController,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _requestEmailChange(_emailController.text);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Request Change'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password: ********',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      _passwordController.clear();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Change Password'),
                            content: TextField(
                              controller: _passwordController,
                              obscureText: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _changePassword(_passwordController.text);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Change Password'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
              ),
              SizedBox(height: 20),
    StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('quiz_results')
      .where('userId', isEqualTo: widget.currentUser.uid)
      .orderBy('result', descending: true)
      .snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data?.docs.isEmpty ?? true) {
      return Container(); // If no quiz result is found, return an empty container
    }

    // Group documents by quizType and select only the first document for each group
    final groupedDocs = Map<String, DocumentSnapshot>();
    snapshot.data!.docs.forEach((doc) {
      final quizType = doc['quizType'];
      if (!groupedDocs.containsKey(quizType)) {
        groupedDocs[quizType] = doc;
      }
    });

    // Display quiz results
    return Column(
      children: groupedDocs.values.map((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final int result = data['result'];
        final int progressPercentage = (result * 10).clamp(0, 100); // Calculate progress percentage

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200], // Adjust background color for dark mode
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black, // Adjust text color for dark mode
                ),
              ),
              ListTile(
                title: Text(
                  '${data['quizType']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: ${data['result']}',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Progress:',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: progressPercentage / 100,
                            backgroundColor: isDarkMode ? Colors.grey[200] : Colors.grey[400], // Adjusted background color for dark mode
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Color.fromRGBO(144,112,255,1) : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.65 * progressPercentage / 100,
                          child: Text(
                            '$progressPercentage%',
                            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black), // Adjust text color for dark mode
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Questions Answered: ${data['questionLength']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
),
SizedBox(height: 20),

StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('quiz_results2')
      .where('userId', isEqualTo: widget.currentUser.uid)
      .orderBy('result', descending: true)
      .snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data?.docs.isEmpty ?? true) {
      return Container(); // If no quiz result is found, return an empty container
    }

    // Group documents by quizType and select only the first document for each group
    final groupedDocs = Map<String, DocumentSnapshot>();
    snapshot.data!.docs.forEach((doc) {
      final quizType = doc['quizType'];
      if (!groupedDocs.containsKey(quizType)) {
        groupedDocs[quizType] = doc;
      }
    });

    // Display quiz results
    return Column(
      children: groupedDocs.values.map((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final int result = data['result'];
        final int progressPercentage = (result * 10).clamp(0, 100); // Calculate progress percentage

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200], // Adjust background color for dark mode
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black, // Adjust text color for dark mode
                ),
              ),
              ListTile(
                title: Text(
                  '${data['quizType']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: ${data['result']}',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Progress:',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: progressPercentage / 100,
                            backgroundColor: isDarkMode ? Colors.grey[200] : Colors.grey[400], // Adjusted background color for dark mode
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Color.fromRGBO(144,112,255,1) : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.65 * progressPercentage / 100,
                          child: Text(
                            '$progressPercentage%',
                            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black), // Adjust text color for dark mode
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Questions Answered: ${data['questionLength']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
),
SizedBox(height: 20),
StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('quiz_results3')
      .where('userId', isEqualTo: widget.currentUser.uid)
      .orderBy('result', descending: true)
      .snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data?.docs.isEmpty ?? true) {
      return Container(); // If no quiz result is found, return an empty container
    }

    // Group documents by quizType and select only the first document for each group
    final groupedDocs = Map<String, DocumentSnapshot>();
    snapshot.data!.docs.forEach((doc) {
      final quizType = doc['quizType'];
      if (!groupedDocs.containsKey(quizType)) {
        groupedDocs[quizType] = doc;
      }
    });

    // Display quiz results
    return Column(
      children: groupedDocs.values.map((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final int result = data['result'];
        final int progressPercentage = (result * 10).clamp(0, 100); // Calculate progress percentage

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200], // Adjust background color for dark mode
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black, // Adjust text color for dark mode
                ),
              ),
              ListTile(
                title: Text(
                  '${data['quizType']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: ${data['result']}',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Progress:',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: progressPercentage / 100,
                            backgroundColor: isDarkMode ? Colors.grey[200] : Colors.grey[400], // Adjusted background color for dark mode
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Color.fromRGBO(144,112,255,1) : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.65 * progressPercentage / 100,
                          child: Text(
                            '$progressPercentage%',
                            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black), // Adjust text color for dark mode
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Questions Answered: ${data['questionLength']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
),
SizedBox(height: 20),
StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('quiz_results4')
      .where('userId', isEqualTo: widget.currentUser.uid)
      .orderBy('result', descending: true)
      .snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data?.docs.isEmpty ?? true) {
      return Container(); // If no quiz result is found, return an empty container
    }

    // Group documents by quizType and select only the first document for each group
    final groupedDocs = Map<String, DocumentSnapshot>();
    snapshot.data!.docs.forEach((doc) {
      final quizType = doc['quizType'];
      if (!groupedDocs.containsKey(quizType)) {
        groupedDocs[quizType] = doc;
      }
    });

    // Display quiz results
    return Column(
      children: groupedDocs.values.map((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final int result = data['result'];
        final int progressPercentage = (result * 10).clamp(0, 100); // Calculate progress percentage

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200], // Adjust background color for dark mode
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black, // Adjust text color for dark mode
                ),
              ),
              ListTile(
                title: Text(
                  '${data['quizType']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: ${data['result']}',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Progress:',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: progressPercentage / 100,
                            backgroundColor: isDarkMode ? Colors.grey[200] : Colors.grey[400], // Adjusted background color for dark mode
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Color.fromRGBO(144,112,255,1) : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.65 * progressPercentage / 100,
                          child: Text(
                            '$progressPercentage%',
                            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black), // Adjust text color for dark mode
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Questions Answered: ${data['questionLength']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
),
SizedBox(height: 20),
StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('quiz_results5')
      .where('userId', isEqualTo: widget.currentUser.uid)
      .orderBy('result', descending: true)
      .snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data?.docs.isEmpty ?? true) {
      return Container(); // If no quiz result is found, return an empty container
    }

    // Group documents by quizType and select only the first document for each group
    final groupedDocs = Map<String, DocumentSnapshot>();
    snapshot.data!.docs.forEach((doc) {
      final quizType = doc['quizType'];
      if (!groupedDocs.containsKey(quizType)) {
        groupedDocs[quizType] = doc;
      }
    });

    // Display quiz results
    return Column(
      children: groupedDocs.values.map((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final int result = data['result'];
        final int progressPercentage = (result * 10).clamp(0, 100); // Calculate progress percentage

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200], // Adjust background color for dark mode
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black, // Adjust text color for dark mode
                ),
              ),
              ListTile(
                title: Text(
                  '${data['quizType']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: ${data['result']}',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Progress:',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: progressPercentage / 100,
                            backgroundColor: isDarkMode ? Colors.grey[200] : Colors.grey[400], // Adjusted background color for dark mode
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Color.fromRGBO(144,112,255,1) : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.65 * progressPercentage / 100,
                          child: Text(
                            '$progressPercentage%',
                            style: TextStyle(color: isDarkMode ? Colors.black : Colors.black), // Adjust text color for dark mode
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Questions Answered: ${data['questionLength']}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color for dark mode
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
),
SizedBox(height: 20),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginForm()),
                  );
                },
                child: Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
