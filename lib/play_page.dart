import 'package:flutter/material.dart';
import 'level1.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LevelButton(level: 1, isLocked: false),
            LevelButton(level: 2, isLocked: true),
            LevelButton(level: 3, isLocked: true),
            LevelButton(level: 4, isLocked: true),
            LevelButton(level: 5, isLocked: true),
            LevelButton(level: 6, isLocked: true),
          ],
        ),
      ),
    );
  }
}

class LevelButton extends StatelessWidget {
  final int level;
  final bool isLocked;

  LevelButton({required this.level, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: isLocked ? null : () => _handleLevelSelected(context,level),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          'Level $level',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

 void _handleLevelSelected(BuildContext context, int selectedLevel) {
  // Handle level selection logic here
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => generateQuestionsPage(selectedLevel)),
  );
  // You can navigate to another page or perform any other action as needed.
}

Widget generateQuestionsPage(int level) {
  // Depending on the level, return the corresponding questions page
  switch (level) {
    case 1:
      return Level1QuestionsPage();
      // case 2:
      //   return Level2QuestionsPage();
      // case 3:
      //   return Level3QuestionsPage();
      // case 4:
      //   return Level4QuestionsPage();
      // case 5:
      //   return Level5QuestionsPage();
      // case 6:
      //   return Level6QuestionsPage();
    default:
      return Container(); // Handle default case or return an empty container
  }
}
}


