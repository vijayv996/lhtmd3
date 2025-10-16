import 'package:analog_timer/analog_timer.dart';
import 'package:flutter/material.dart';
import 'package:lhtmd3/models/pomo_entry.dart';
import 'package:lhtmd3/pages/pomodoro_stats.dart';
import 'package:lhtmd3/services/database.dart';
import 'package:lhtmd3/widgets/pomo_habit_selector.dart';

enum PomodoroState { focus, shortBreak, longBreak }

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> with TickerProviderStateMixin {
  late AnalogTimerController _controller;

  PomodoroState _currentState = PomodoroState.focus;
  int _pomodoroCount = 0;
  DateTime _startTime = DateTime.now();
  String? _selectedPomoHabit;
  int? _habitId;

  static const Duration _focusDuration = Duration(minutes: 25);
  static const Duration _shortBreakDuration = Duration(minutes: 5);
  static const Duration _longBreakDuration = Duration(minutes: 20);

  @override
  void initState() {
    super.initState();
    _controller = AnalogTimerController(duration: _focusDuration);
    _controller.initializeAnimation(this);
    _controller.onExpired = () async {
      _nextPomodoro();
      if(_currentState == PomodoroState.focus) return;
      final databaseService = DatabaseService();
      final pomoEntry = PomoEntry(
        startTime: _startTime,
        endTime: DateTime.now(), 
        duration: 25,
        focusName: _selectedPomoHabit ?? 'focus',
        habitId: _habitId,
      );
      await databaseService.insertPomodoro(pomoEntry);
    };
  }

  void _resetPomodoro() {
    setState(() {
      _currentState = PomodoroState.focus;
      _pomodoroCount = 0;
      _controller.reset(_focusDuration);
    });
  }

  void _nextPomodoro() {
    setState(() {
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
    });
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PomodoroStats(),
                )
              );
            }, 
            icon: Icon(Icons.analytics)
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentState == PomodoroState.focus
                ? 'Focus'
                : 'Break',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
              ),
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
                  direction: AnalogTimerDirection.antiClockwise,
                  size: 250,
                );
              },
            ),
            SizedBox(height: 48),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context, 
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return PomoHabitSelector(
                      onHabitSelected: (habitName, int? habitId) {
                        setState(() {
                          _selectedPomoHabit = habitName;
                          _habitId = habitId;
                        });
                      },
                    );
                  },
                );
              }, 
              child: Text(
                _selectedPomoHabit != null
                  ? "$_selectedPomoHabit >"
                  : "focus >"
              )
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(_controller.isRunning) {
                        _controller.pause();
                      } else if(_controller.isPaused) {
                        _controller.resume();
                      } else {
                        _controller.start();
                        _startTime = DateTime.now();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(130, 80),
                    shape: _controller.isRunning
                      ? RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(Radius.circular(18))
                      )
                      : RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(Radius.circular(50))
                      )
                  ),
                  child: Icon(
                    _controller.isRunning
                      ? Icons.pause
                      : Icons.play_arrow,
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPomodoro,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 80),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(Radius.circular(18))
                    ),
                  ),
                  child: const Icon(Icons.skip_next, size: 22,),
                ),
                ElevatedButton(
                  onPressed: _resetPomodoro,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 80),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(Radius.circular(18))
                    ),
                  ),
                  child: const Icon(Icons.refresh, size: 22,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
