import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signInWithPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', true);
                  // Navigate to HomePage upon successful sign-in
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false, // Remove all previous routes from the stack
                  );  
                } catch (error) {
                  // Handle sign-in errors
                  _handleLoginError(error);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Check if the user already exists before signing up
                  await _signUpWithEmailCheck();
                } catch (error) {
                  // Handle sign-up errors
                  _handleSignUpError(error);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUpWithEmailCheck() async {
    try {
      // Directly use the result of the await call without assigning it to a variable
      await Supabase.instance.client
          .from('auth.users')
          .select()
          .eq('email', emailController.text.trim())
          .single();

      // Handle existing user
      _showErrorDialog('An account with this email already exists. Please log in.');
    } catch (error) {
      // Handle case where no user is found
      await _signUpWithDelay();
      _showInfoDialog('Please check your email for a confirmation link.');
    }
  }

  Future<void> _signUpWithDelay() async {
    // Introduce a delay before signing up to avoid rate limit issues
    await Future.delayed(Duration(seconds: 5));
    await Supabase.instance.client.auth.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future<void> _handleLoginError(dynamic error) async {
    if (error is AuthException) {
      final errorMessage = error.message;
      if (errorMessage.toLowerCase().contains('email not confirmed')) {
        _showErrorDialog('Email not confirmed. Please check your email for a confirmation link.');
      } else if (errorMessage.toLowerCase().contains('invalid credentials')) {
        _showErrorDialog('Invalid email or password. Please try again.');
      } else if (errorMessage.toLowerCase().contains('user not found')) {
        _showErrorDialog('User not found. Please sign up first.');
      } else {
        _showErrorDialog('Login failed: $errorMessage');
        // Handle other login errors
      }
    }
  }

  Future<void> _handleSignUpError(dynamic error) async {
    if (error is AuthException) {
      final errorMessage = error.message;
      if (errorMessage.toLowerCase().contains('user with this email already exists')) {
        _showErrorDialog('An account with this email already exists. Please log in.');
      } else {
        print('Sign up failed: $error');
        // Handle other sign-up errors
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
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

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: Text(message),
          actions: [
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
