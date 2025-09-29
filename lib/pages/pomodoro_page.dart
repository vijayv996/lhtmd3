import 'package:analog_timer/analog_timer.dart';
import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> with TickerProviderStateMixin {
  late AnalogTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnalogTimerController(duration: Duration(minutes: 5),);
    _controller.initializeAnimation(this); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller, 
              builder: (context, child) {
                return AnalogTimer(
                  progress: _controller.progress,
                  isRunning: _controller.isRunning,
                  animationValue: _controller.animationValue,
                  remainingTimeText: _controller.formattedTime,
                  size: 250,
                );
              }
            ),
            SizedBox(height: 48,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {
                  if(_controller.isRunning) {
                    _controller.pause();
                  } else if(_controller.isPaused) {
                    _controller.resume();
                  } else {
                    _controller.start();
                  }
                }, child: Text(_controller.isRunning ? 'Pause' : _controller.isPaused ? 'Resume' : 'Start')),
                ElevatedButton(onPressed: _controller.reset, child: const Text('Reset'),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
