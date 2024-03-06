import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Level1QuestionsPage extends StatefulWidget {
  @override
  _Level1QuestionsPageState createState() => _Level1QuestionsPageState();
}

class _Level1QuestionsPageState extends State<Level1QuestionsPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int attemptsLeft = 2;
  int starCounter = 0;
  int questionCounter = 1;
  String correctAnswerMessage = '';
  String incorrectAnswerMessage = '';

  final List<Map<String, dynamic>> level1Questions = [
  {'letter': 'A', 'morseCode': '.-', 'choices': ['A', 'B', 'C', 'D']},
  {'letter': 'B', 'morseCode': '-...', 'choices': ['B', 'C', 'D', 'A']},
  {'letter': 'C', 'morseCode': '-.-.', 'choices': ['C', 'D', 'A', 'B']},
  {'letter': 'D', 'morseCode': '-..', 'choices': ['D', 'A', 'B', 'C']},
  {'letter': 'E', 'morseCode': '.', 'choices': ['E', 'A', 'B', 'C']},
  {'letter': 'F', 'morseCode': '..-.', 'choices': ['F', 'B', 'C', 'D']},
  {'letter': 'G', 'morseCode': '--.', 'choices': ['G', 'C', 'D', 'A']},
  {'letter': 'H', 'morseCode': '....', 'choices': ['H', 'D', 'A', 'B']},
  {'letter': 'I', 'morseCode': '..', 'choices': ['I', 'A', 'B', 'C']},
  {'letter': 'J', 'morseCode': '.---', 'choices': ['J', 'B', 'C', 'D']},
];


  late List<Map<String, dynamic>> shuffledQuestions;
  late AnimationController _animationController;
  late Animation<double> _fadeInOut;

  @override
  void initState() {
    super.initState();
    shuffledQuestions = _shuffleQuestions();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeInOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation immediately when the page loads
    _animationController.forward();

    // Play initial Morse code vibration
    _playMorseCodeVibration(shuffledQuestions[currentIndex]['morseCode']);
  }

  List<Map<String, dynamic>> _shuffleQuestions() {
    List<Map<String, dynamic>> shuffledList = List.from(level1Questions);
    shuffledList.shuffle(Random());
    return shuffledList;
  }

  Future<void> _playMorseCodeVibration(String morseCode) async {
    if (morseCode.isNotEmpty) {
      for (int i = 0; i < morseCode.length; i++) {
        if (morseCode[i] == '.') {
          // Short vibration for dot
          Vibration.vibrate(duration: 50);
        } else if (morseCode[i] == '-') {
          // Longer vibration for dash
          Vibration.vibrate(duration: 300);
        }

        // Wait for a short duration between dots and dashes
        await Future.delayed(Duration(milliseconds: 1000));
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level 1 Questions'),
        actions: [
          // Star counter at the top right corner
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 4),
                Text('$starCounter'),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question counter
          Text(
            'Question $questionCounter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Handle tap to repeat Morse code vibration
              _handleCardTap();
            },
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                          opacity: _fadeInOut,
                          child: Text(
                            shuffledQuestions[currentIndex]['morseCode'],
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle button press logic, check if the selected option is correct
                  _handleOptionSelected(shuffledQuestions[currentIndex]['choices'][0]);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 40,
                  child: Center(
                    child: Text(
                      shuffledQuestions[currentIndex]['choices'][0],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle button press logic, check if the selected option is correct
                  _handleOptionSelected(shuffledQuestions[currentIndex]['choices'][1]);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 40,
                  child: Center(
                    child: Text(
                      shuffledQuestions[currentIndex]['choices'][1],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle button press logic, check if the selected option is correct
                  _handleOptionSelected(shuffledQuestions[currentIndex]['choices'][2]);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 40,
                  child: Center(
                    child: Text(
                      shuffledQuestions[currentIndex]['choices'][2],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle button press logic, check if the selected option is correct
                  _handleOptionSelected(shuffledQuestions[currentIndex]['choices'][3]);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 40,
                  child: Center(
                    child: Text(
                      shuffledQuestions[currentIndex]['choices'][3],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Correct and incorrect answer messages at the bottom
          Text(
            correctAnswerMessage,
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
          Text(
            incorrectAnswerMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Handle tap to repeat Morse code vibration
  void _handleCardTap() {
    // Reset the animation
    _animationController.reset();
    _animationController.forward();

    // Play Morse code vibration again
    _playMorseCodeVibration(shuffledQuestions[currentIndex]['morseCode']);
  }

  // Handle option selected
  void _handleOptionSelected(String selectedOption) {
    // Implement your logic to check if the selected option is correct
    if (selectedOption == shuffledQuestions[currentIndex]['letter']) {
      // Correct answer
      // Move to the next question or navigate to a result page if needed

      // Increase star counter
      setState(() {
        starCounter++;
      });

      // Reset correct and incorrect answer messages
      setState(() {
        correctAnswerMessage = '';
        incorrectAnswerMessage = '';
      });

      // Display correct answer message
      setState(() {
        correctAnswerMessage = 'Correct! Well done.';
      });

      // For example, move to the next question
      if (currentIndex < shuffledQuestions.length - 1) {
        setState(() {
          currentIndex++;
          attemptsLeft = 2; // Reset attempts for the next question
          questionCounter++; // Increment question counter
        });
        _animationController.reset();
        _animationController.forward();
        _playMorseCodeVibration(shuffledQuestions[currentIndex]['morseCode']);
      } else {
        // All questions answered, navigate to the result page or perform other actions
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage()));
      }
    } else {
      // Incorrect answer
      setState(() {
        attemptsLeft--;

        if (attemptsLeft == 1) {
          // First wrong attempt, show incorrect answer message
          incorrectAnswerMessage = 'Incorrect answer. Try again.';
        } else if (attemptsLeft == 0) {
          // Second wrong attempt, show incorrect answer message with correct answer
          incorrectAnswerMessage =
              'Incorrect answer. The correct answer is ${shuffledQuestions[currentIndex]['letter']}.';
          
          // If no attempts left, move to the next question
          if (currentIndex < shuffledQuestions.length - 1) {
            setState(() {
              currentIndex++;
              attemptsLeft = 2; // Reset attempts for the next question
              questionCounter++; // Increment question counter
            });
            _animationController.reset();
            _animationController.forward();
            _playMorseCodeVibration(shuffledQuestions[currentIndex]['morseCode']);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    Vibration.cancel();
    super.dispose();
  }
}
