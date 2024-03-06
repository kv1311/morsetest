import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

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
    await vibrateMorse(morseCodeMap[letters[newIndex]] ?? '');
  }

  Future<void> vibrateMorse(String char) async {
    if (char.isNotEmpty) {
      for (int i = 0; i < char.length; i++) {
        if (char[i] == '.') {
          // Short vibration for dot
          Vibration.vibrate(duration: 50);
        } else if (char[i] == '-') {
          // Longer vibration for dash
          Vibration.vibrate(duration: 300);
        }

        // Wait for a short duration between dots and dashes
        await Future.delayed(Duration(milliseconds: 1000));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double cardWidthPercentage = 0.6; // 80% of the screen width
    double cardHeightPercentage = 0.4; // 30% of the screen height

    const EdgeInsets cardPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20);

    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Handle tap to repeat vibration and text-to-speech
              _handleCardTap();
            },
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(20),
              child: SizedBox(
                width: screenWidth * cardWidthPercentage,
                height: screenHeight * cardHeightPercentage,
                child: Padding(
                  padding: cardPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          letters[currentIndex],
                          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                          opacity: _fadeInOut,
                          child: Text(
                            morseCodeMap[letters[currentIndex]] ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
    );
  }

  // Handle tap to repeat vibration and text-to-speech
  void _handleCardTap() {
    // Reset the animation
    _animationController.reset();
    _animationController.forward();

    // Delay and speak the current letter
    delayAndSpeak(currentIndex);
  }

  @override
  void dispose() {
    _animationController.dispose();
    Vibration.cancel();
    super.dispose();
  }
}
