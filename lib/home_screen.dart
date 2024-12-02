import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({super.key, required this.userEmail});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  @override
  void initState() {
    super.initState();
    _checkFirstTimeForUser();

  }

  Future<void> _checkFirstTimeForUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = 'isFirstTime_${widget.userEmail}';
    String nameKey = 'userName_${widget.userEmail}';
    bool isFirstTime = prefs.getBool(userKey) ?? true;

    if (isFirstTime) {
      _showUserDetailsDialog(userKey);
    } else {
      setState(() {

      });
     userName =  prefs.getString(nameKey);
    }
  }

  void _showUserDetailsDialog(String userKey) {
    String name = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your name'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              name = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(userKey, false);
                  await prefs.setString('userName_${widget.userEmail}', name);
                  setState(() {
                    userName = name;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Email: ${widget.userEmail}'),
            Text('Your Name: $userName'),
          ],
        ),
      ),
    );
  }
}