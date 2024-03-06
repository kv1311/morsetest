import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'learn_page.dart';
import 'login_page.dart';
import 'play_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.3;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Morse Code',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isLoggedIn', false);
                      // Navigate to LoginPage after logout
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to LearnPage or perform Learn-related actions
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LearnPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(buttonWidth, 80), // Set minimum size
              ),
              child: SizedBox(
                width: buttonWidth,
                child: Center(
                  child: Text(
                    'Learn',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to PlayPage or perform Play-related actions
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>PlayPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(buttonWidth, 80), // Set minimum size
              ),
              child: SizedBox(
                width: buttonWidth,
                child: Center(
                  child: Text(
                    'Play',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
