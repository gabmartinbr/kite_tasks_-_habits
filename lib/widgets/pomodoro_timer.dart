import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  static const int maxSeconds = 1500; // 25 minutos
  int seconds = maxSeconds;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() => timer = null);
  }

  void resetTimer() {
    stopTimer();
    setState(() => seconds = maxSeconds);
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (seconds / maxSeconds);
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    String timeStr = "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";

    return GestureDetector(
      onTap: () => timer == null ? startTimer() : stopTimer(),
      onLongPress: resetTimer,
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipOval(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) => Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: value,
                      child: Container(width: 160, color: Colors.white.withOpacity(0.08)),
                    ),
                  ),
                ),
                Center(
                  child: Text(timeStr, 
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w200, letterSpacing: -1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(timer == null ? "TAP TO FOCUS" : "FOCUSING...", 
            style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ],
      ),
    );
  }
}