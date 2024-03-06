import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://xeoadmvcqkiugmxoqpwa.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhlb2FkbXZjcWtpdWdteG9xcHdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg1NzQzMjEsImV4cCI6MjAyNDE1MDMyMX0.3x8HOciRdmPqVpAc1PN3SrVXSri_4GsMd_xiklR0vw4',
    );
  } catch (error) {
    // Handle initialization errors, e.g., show an error dialog or log the error
    print('Supabase initialization failed: $error');
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn and Play App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFAEED1),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFA6B1E1),
        ),
      ),
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}
