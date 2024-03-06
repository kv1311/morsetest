import 'package:flutter/material.dart';
import 'supabase_config.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supabaseClient = supabaseClient(
      '','',
    );

    final ColorScheme colorScheme = ColorScheme(
      primary: Colors.orangeAccent, // Warmer primary color
      secondary: Colors.amber, // Use secondary as an accent color
      surface: Colors.white,
      background: Color(0xFFF5EEDC), // Light beige background color
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      error: Colors.red,
      brightness: Brightness.light,
      onError: Colors.white,
    );

    final ThemeData theme = ThemeData.from(
      colorScheme: colorScheme,
      textTheme: Typography.material2018(platform: TargetPlatform.android).white.apply(
        displayColor: Colors.black,
        bodyColor: Colors.black,
      ).copyWith(
        headline4: TextStyle(fontSize: 48, fontWeight: FontWeight.bold), // Larger header
        headline6: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Larger subheader
        bodyText1: TextStyle(fontSize: 20), // Larger body text
        bodyText2: TextStyle(fontSize: 18), // Larger body text
      ),
    );

    return MaterialApp(
      title: 'Learn and Play App',
      theme: theme,
      home: HomePage(supabaseClient: supabaseClient),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LearnPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40), // Adjust the padding
              ),
              child: Text(
                'Learn',
                style: TextStyle(fontSize: 30), // Adjust the font size
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to PlayPage or perform Play-related actions
                print('Play button pressed');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 40), // Adjust the padding
              ),
              child: Text(
                'Play',
                style: TextStyle(fontSize: 30), // Adjust the font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  final List<String> letters = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));
  final Map<String, String> morseCodeMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....',
    'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---', 'P': '.--.',
    'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..',
  };

  int currentIndex = 0;
  bool isVoiceEnabled = false;

  late AnimationController _animationController;
  late Animation<double> _fadeInOut;

  @override
  void initState() {
    super.initState();
    initializeTts();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeInOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation immediately when the page loads
    _animationController.forward();

    // Speak the first letter
    if (isVoiceEnabled) {
      speakLetter(letters[currentIndex]);
    }
  }

  Future<void> initializeTts() async {
    await flutterTts.setLanguage("en-US");
  }

  Future<void> speakLetter(String letter) async {
    await flutterTts.speak(letter);
  }

  Future<void> delayAndSpeak(int newIndex) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (isVoiceEnabled) {
      await speakLetter(letters[newIndex]);
    }
  }

  Future<void> _performHapticFeedback() async {
    // Use Vibration for haptic feedback
    if (await Vibration.hasVibrator() ?? false) {
      // Vibrate for a short duration for dots
      await Vibration.vibrate(duration: 50);
    }
    // Add a delay between dots and dashes (adjust the duration based on your preference)
    await Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      letters[currentIndex],
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    FadeTransition(
                      opacity: _fadeInOut,
                      child: Text(
                        morseCodeMap[letters[currentIndex]] ?? '',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentIndex > 0) {
                      setState(() {
                        currentIndex--;
                      });
                      _animationController.reset();
                      _animationController.forward();
                      delayAndSpeak(currentIndex);
                    }
                  },
                  child: Icon(Icons.arrow_left),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (currentIndex < letters.length - 1) {
                      setState(() {
                        currentIndex++;
                      });
                      _animationController.reset();
                      _animationController.forward();
                      delayAndSpeak(currentIndex);
                    }
                  },
                  child: Icon(Icons.arrow_right),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enable Voice:'),
                Switch(
                  value: isVoiceEnabled,
                  onChanged: (value) async {
                    setState(() {
                      isVoiceEnabled = value;
                    });
                    if (isVoiceEnabled) {
                      await speakLetter(letters[currentIndex]);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    Vibration.cancel();
    super.dispose();
  }
}
