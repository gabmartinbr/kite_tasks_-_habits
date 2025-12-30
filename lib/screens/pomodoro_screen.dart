import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/pomodoro_timer.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CupertinoNavigationBar(
        backgroundColor: Colors.black,
        middle: Text("Focus Mode", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PomodoroTimer(),
            const SizedBox(height: 40),
            const Text(
              "Mantén la concentración en tu tarea actual.",
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}