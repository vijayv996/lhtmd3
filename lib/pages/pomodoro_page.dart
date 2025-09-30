import 'package:analog_timer/analog_timer.dart';
import 'package:flutter/material.dart';

enum PomodoroState { focus, shortBreak, longBreak }

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

// TODO: add pomodoro tracking

class _PomodoroState extends State<Pomodoro> with TickerProviderStateMixin {
  late AnalogTimerController _controller;

  PomodoroState _currentState = PomodoroState.focus;
  int _pomodoroCount = 0;

  static const Duration _focusDuration = Duration(minutes: 25);
  static const Duration _shortBreakDuration = Duration(minutes: 5);
  static const Duration _longBreakDuration = Duration(minutes: 20);

  @override
  void initState() {
    super.initState();
    _controller = AnalogTimerController(duration: _focusDuration);
    _controller.initializeAnimation(this);
    _controller.onExpired = _nextPomodoro;
  }

  void _resetPomodoro() {
    _currentState = PomodoroState.focus;
    _pomodoroCount = 0;
    _controller.reset(_focusDuration);
  }

  void _nextPomodoro() {
    if(_currentState == PomodoroState.focus) {
      _pomodoroCount++;
      if(_pomodoroCount > 0 && _pomodoroCount % 4 == 0) {
        _currentState = PomodoroState.longBreak;
        _controller.reset(_longBreakDuration);
      } else {
        _currentState = PomodoroState.shortBreak;
        _controller.reset(_shortBreakDuration);
      }
    } else {
      _currentState = PomodoroState.focus;
      _controller.reset(_focusDuration);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentState == PomodoroState.focus
                ? 'Focus'
                : 'Break',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 48,),
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
              },
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(_controller.isRunning) {
                      _controller.pause();
                    } else if(_controller.isPaused) {
                      _controller.resume();
                    } else {
                      _controller.start();
                    }
                  },
                  child: Text(
                    _controller.isRunning
                        ? 'Pause'
                        : _controller.isPaused
                        ? 'Resume'
                        : 'Start',
                  ),
                ),
                ElevatedButton(
                  onPressed: _resetPomodoro,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _nextPomodoro,
                  child: const Text('Skip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
