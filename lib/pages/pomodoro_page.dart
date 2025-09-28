import 'package:analog_timer/analog_timer.dart';
import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  final AnalogTimerController controller;

  const Pomodoro({super.key, required this.controller});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, child) {
                return AnalogTimer(
                  progress: widget.controller.progress,
                  isRunning: widget.controller.isRunning,
                  animationValue: widget.controller.animationValue,
                  remainingTimeText: widget.controller.formattedTime,
                  size: 250,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(widget.controller.isRunning) {
                      widget.controller.pause();
                    } else if(widget.controller.isPaused) {
                      widget.controller.resume();
                    } else {
                      widget.controller.start();
                    }
                  },
                  child: Icon(Icons.start),
                ),
                ElevatedButton(onPressed: widget.controller.reset, child: Icon(Icons.restart_alt))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
